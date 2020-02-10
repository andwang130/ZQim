package grpcserver

import (
	"comit/config"
	"comit/fxsrv"
	"comit/manage"
	"comit/modle"
	"comit/proto/grpc"
	"context"
	"fmt"
	"github.com/gogo/protobuf/proto"
	"google.golang.org/grpc"
	"net"
)

type Server struct {

}

//其他服务器发送过来的中转消息
func (this *Server)Transfer(ctx context.Context, message *intercom.OneMessage )(*intercom.AckMessage,error){
	var ack =&intercom.AckMessage{Status:0,Rek:message.Rek}
	//获取到要中转消息的用户连接
	con,ok:=manage.ConManage.GetConnect(message.Receiver)
	if !ok{
		//该用户不在当前服务器，已经下线
		return ack,nil
	}
	 buf,err:=proto.Marshal(message)
	 if err!=nil{
	 	//todo log
		 return ack,nil
	 }
	var reqest =&fxsrv.Request{
		Type:config.OneMessage,
		Body:buf,
		BodyLen:uint32(len(buf)),
	}
	con.Write(reqest)
	manage.AckMange.Push(&manage.AckMessage{
		Body:buf,
		Receiver:con.GetId(),
		Msgid:message.Rek,
		GropOrOne:config.OneMessage,

	})
	//todo
	return ack,nil
}
func (this *Server)Grouptranfer(ctx context.Context,message *intercom.GreupTranferReq)(*intercom.AckMessage,error)  {
	fmt.Println("一条群聊消息转发")
	var ack =&intercom.AckMessage{Status:0,Rek:message.Message.Rek}
	buf, err := proto.Marshal(message.Message)
	if err != nil {
		return ack,nil
	}
	var reqest = &fxsrv.Request{
		Type:    config.GorupMessage,
		Body:    buf,
		BodyLen: uint32(len(buf)),
	}

	for _,v:=range message.Receivers {
		con, ok := manage.ConManage.GetConnect(v)
		if !ok {
			//该用户不在当前服务器，已经下线
			return ack,nil
		}
		manage.AckMange.Push(&manage.AckMessage{
			Body:buf,
			Receiver:v,
			Msgid:message.Message.Rek,})
		con.Write(reqest)
	}
	return ack,nil
}

func (this *Server)FriendNotify(ctx context.Context,message *intercom.FriendNotife)(*intercom.AckMessage,error)  {

	var ackmessage=&intercom.AckMessage{}
	con,ok:=manage.ConManage.GetConnect(message.Receiver)
	if ok{

		var request=&fxsrv.Request{}
		request.Type=config.FriendNotife
		buf,err:=proto.Marshal(message)
		if err!=nil{

			return ackmessage,nil
		}
		request.Body=buf
		request.BodyLen=uint32(len(buf))
		con.Write(request)
	}

	return ackmessage,nil
}
func (this *Server)FriendAgree(ctx context.Context,mesasge *intercom.Agree)(*intercom.AckMessage,error)  {
	var ackmesasge=&intercom.AckMessage{}
	con,ok:=manage.ConManage.GetConnect(mesasge.Notife.Uid)
	buf,err:=proto.Marshal(mesasge.Notife)
	if err!=nil{
		return ackmesasge,nil
	}
	if ok{

		var request =&fxsrv.Request{
			Type:config.FriendAgree,
			Body:buf,
			BodyLen:uint32(len(buf)),
		}
		con.Write(request)

	}else{
		modle.CreateNotifie(&modle.Notifie{
			Uid:mesasge.Notife.Uid,
			NotifieType:uint32(config.FriendAgree),
			Body:buf,
		})
	}
	return ackmesasge,nil
}
func GrpcServerRun(addr string)  {
	lic,err:=net.Listen("tcp",addr)
	if err!=nil{
		panic(err)
	}
	s:=grpc.NewServer()
	intercom.RegisterGreeterServer(s,&Server{})
	s.Serve(lic)
}
