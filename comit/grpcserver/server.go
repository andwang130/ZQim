package grpcserver

import (
	"comit/config"
	"comit/fxsrv"
	"comit/manage"
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
		Msgid:message.Rek,})
	//todo
	return ack,nil
}
func (this *Server)Grouptranfer(ctx context.Context,message *intercom.GreupTranferReq)(*intercom.AckMessage,error)  {
	fmt.Println("一条群聊消息转发")
	var ack =&intercom.AckMessage{Status:0,Rek:message.Message.Rek}
	for _,v:=range message.Receivers {
		con, ok := manage.ConManage.GetConnect(v)
		if !ok {
			//该用户不在当前服务器，已经下线
			return ack,nil
		}
		buf, err := proto.Marshal(message.Message)
		if err != nil {
			return ack,nil
		}
		var reqest = &fxsrv.Request{
			Type:    config.GorupMessage,
			Body:    buf,
			BodyLen: uint32(len(buf)),
		}
		manage.AckMange.Push(&manage.AckMessage{
			Body:buf,
			Receiver:con.GetId(),
			Msgid:message.Message.Rek,})
		con.Write(reqest)
	}
	return ack,nil
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
