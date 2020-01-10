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
		SendAck(con,msg.Rek,config.AckSaveFail)
		return errors.New("存入离线消息失败")
	}
	SendAck(con,msg.Rek,config.AckSuccess)
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
				_,err:=sv.Client.Transfer(ctx,&intercom.OneMessage{
					Rek:msg.Rek,
					Sender:msg.Sender,
					Receiver:msg.Receiver,
					Msgbody:msg.Msgbody,
					Msgtype:msg.Msgtype,
				})
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

		})

		receiver.Write(request)

	}

	return nil
}
func SendAck(con *fxsrv.Connect,rek uint64,status uint32)  {
	var ackmessage intercom.AckMessage
	ackmessage.Rek=rek
	ackmessage.Status=status
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

func GorupMessageHandle(con *fxsrv.Connect,request *fxsrv.Request)error  {

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
	manage.AckMange.Delete(ackmeesage.Rek)
	modle.DeleteOnemessage(ackmeesage.Rek,con.GetId())
	return nil
}

