package handles

import (
	"comit/config"
	"comit/fxsrv"
	"comit/manage"
	"comit/modle"
	"comit/proto/grpc"
	"comit/rediscache"
	"context"
	"errors"
	"fmt"
	"github.com/golang/protobuf/proto"
	"time"
)

func OneMessageHandle(con *fxsrv.Connect,request *fxsrv.Request)error  {

	var msg intercom.OneMessage
	if proto.Unmarshal(request.Body,&msg)!=nil{

		fmt.Println("Unmarshal")
		return errors.New("message error")
	}
	if msg.Sender!=con.GetId(){
		fmt.Println("Unmarshal")
		return errors.New("id不一致")
	}
	if !rediscache.FriendCheck(msg.Receiver,msg.Sender){
		fmt.Println(con.GetId())
		SendAck(con,msg.Rek,config.AckSaveFail,config.GorupMessage)
		return errors.New("非好友")
	}
	if err:=modle.AddOnemessage(&modle.Onemessage{
		Rek:msg.Rek,
		Sender:msg.Sender,
		Receiver:msg.Receiver,
		Msgtype:msg.Msgtype,
		Body:msg.Msgbody,
		Time:msg.Time,
	});err!=nil{
		//存入离线i消息失败
		fmt.Println(err)
		SendAck(con,msg.Rek,config.AckSaveFail,config.OneMessage)
		return errors.New("存入离线消息失败")
	}
	//返回ack
	SendAck(con,msg.Rek,config.AckSuccess,config.OneMessage)

	receiver,ok:= manage.ConManage.GetConnect(msg.Receiver)
	if !ok{
		//该用户未连接到本地，获取该用户连接的服务器
		user,err:=rediscache.GetUser(msg.Receiver)
		if err!=nil{
			fmt.Println(err)
			fmt.Println("未在redis中找到")
		}else{
			sv,ok:=manage.ComitManage.GetComitServer(user.Srvname)
			if ok{
				ctx,cancel:=context.WithTimeout(context.TODO(),config.GrpcTimeOut)
				defer cancel()
				_,err:=sv.Client.Transfer(ctx,&msg)
				if err!=nil{
					//todo log
				}
			}
		}


	}else{
		//进去Ack队列
		manage.AckMange.Push(&manage.AckMessage{
			Body:request.Body,
			Receiver:msg.Receiver,
			Msgid:msg.Rek,
			GropOrOne:config.OneMessage,


		})

		receiver.Write(request)

	}

	return nil
}
func SendAck(con *fxsrv.Connect,rek uint64,status uint32,msgtype uint32)  {
	var ackmessage intercom.AckMessage
	ackmessage.Rek=rek
	ackmessage.Status=status
	ackmessage.Msgtype=msgtype
	buf,err:=proto.Marshal(&ackmessage)
	if err!=nil{
		//todo log
		return
	}
	var ackreq =&fxsrv.Request{}
	ackreq.Type=config.AckMesage
	ackreq.Body=buf
	ackreq.BodyLen=uint32(len(buf))
	con.Write(ackreq)
}

//群聊消息
func GorupMessageHandle(con *fxsrv.Connect,request *fxsrv.Request)error  {
	var groupmessage intercom.GroupMessage
	if err:=proto.Unmarshal(request.Body,&groupmessage);err!=nil{
		return  errors.New("消息解析失败")
	}

	if groupmessage.Sender!=con.GetId(){

		return errors.New("发送人id不一致")
	}

	//群聊消息以服务器时间为准
	groupmessage.Time=uint32(time.Now().Unix())
	//获取该群聊的所有用户id
	userlist,err:=rediscache.GetGroupUsers(groupmessage.Groupid)


	//用户不在该群组
	if !rediscache.GroupMebersCheck(groupmessage.Groupid,groupmessage.Sender){
		fmt.Println(con.GetId())
		SendAck(con,groupmessage.Rek,config.AckSaveFail,config.GorupMessage)
		return errors.New("不在该群组")
	}
	err=modle.CreateGroupMessage(
		&modle.Message{
			Rek:groupmessage.Rek,
			Body:groupmessage.Msgbody,
			Time:groupmessage.Time,
			Msgtype:groupmessage.Msgtype,
			Sender:groupmessage.Sender,
			Groupid:groupmessage.Groupid,
		})
	if err!=nil{
		SendAck(con,groupmessage.Rek,config.AckSaveFail,config.GorupMessage)
		return errors.New("写入数据库失败")
	}

	var usermessages=make([]*modle.GroupUserMessage,0,len(userlist))
	var locclient =make([]*fxsrv.Connect,0,len(userlist))
	var remoteclient=make(map[string][]uint32)
	for i:=0;i<len(userlist);i++{
		uid:=userlist[i]
		if uid==con.GetId(){
			continue
		}
		receiver,ok:=manage.ConManage.GetConnect(uid)
		if ok{
			locclient=append(locclient,receiver)
		}else{
			user,err:=rediscache.GetUser(uid)
			if err==nil{
				remoteclient[user.Srvname]=append(remoteclient[user.Srvname],uid)
			}
		}

		usermessages=append(usermessages,&modle.GroupUserMessage{
			Rek:groupmessage.Rek,
			Receiver: uid,
		})
	}
 	if modle.CreateGroupUserMessage(usermessages)!=nil{
		SendAck(con,groupmessage.Rek,config.AckSaveFail,config.GorupMessage)
		return errors.New("写入数据库失败")
	}

	SendAck(con,groupmessage.Rek,config.AckSuccess,config.GorupMessage)
	//修改了时间，重新生成buf,进入Ack队列
	 buf,err:=proto.Marshal(&groupmessage)
	 if err!=nil{
	 	//todo log
	 }
	for _,v:=range locclient{
			manage.AckMange.Push(&manage.AckMessage{
				Body:    buf,
				Receiver: v.GetId(),
				Msgid:    groupmessage.Rek,
				GropOrOne:config.GorupMessage,
			})
			request.Body=buf
			request.BodyLen=uint32(len(buf))
			v.Write(request)

	}
	for key,v:=range remoteclient{

		srv,ok:=manage.ComitManage.GetComitServer(key)
		if ok{
			ctx,cancle:=context.WithTimeout(context.TODO(),time.Second*2)
			defer cancle()
			srv.Client.Grouptranfer(ctx,&intercom.GreupTranferReq{
				Message:&groupmessage,
				Receivers:v,
			})
		}
	}
	return nil
}

//ack消息
func AckMesageHandle(con *fxsrv.Connect,request *fxsrv.Request) error {
	var ackmeesage intercom.AckMessage
	err:=proto.Unmarshal(request.Body,&ackmeesage)
	//ack消息失败，不做处理，等待ACK再次重发
	if err!=nil{
		return nil
	}
	//删除ack消息
	fmt.Println(con.GetId(),"的ack消息",ackmeesage.Rek)
	manage.AckMange.Delete(ackmeesage.Rek,con.GetId())
	if ackmeesage.Msgtype==1 {
		//单聊消息
		modle.DeleteOnemessage(ackmeesage.Rek, con.GetId())
	}else if ackmeesage.Msgtype==2{
		//群聊消息
		modle.DeleteGroupUserMessage(ackmeesage.Rek,con.GetId())
	}

	return nil
}

func DeleteManyHandle(con *fxsrv.Connect,request *fxsrv.Request)error  {
	var many intercom.DeleteManyMessages
	if err:=proto.Unmarshal(request.Body,&many);err!=nil{
		SendAckMany(con,many.Reks,1)
		return nil
	}
	if many.Msgtype==1 {
		//单聊消息
		if modle.DeleteOnemessageMany(many.Reks,con.GetId())!=nil{

			SendAckMany(con,many.Reks,0)
			return nil
		}
	}else if many.Msgtype==2{
		//群聊消息
		if modle.DeleteGroupUserMessageMany(many.Reks,con.GetId())!=nil{
			SendAckMany(con,many.Reks,0)
			return nil
		}
	}

	SendAckMany(con,many.Reks,1)
	return nil
}
func SendAckMany(con *fxsrv.Connect,reks []uint64,status uint32)  {
	var ackmessage intercom.AckManyMesasges
	ackmessage.Reks=reks
	ackmessage.Status=status
	buf,err:=proto.Marshal(&ackmessage)
	if err!=nil{
		//todo log
		return
	}
	var ackreq =&fxsrv.Request{}
	ackreq.Type=config.AckManyMessage
	ackreq.Body=buf
	ackreq.BodyLen=uint32(len(buf))
	con.Write(ackreq)
}
