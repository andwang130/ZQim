package grpcserver

import (
	"comit/config"
	"comit/fxsrv"
	"comit/manage"
	"comit/proto/grpc"
	"context"
	"github.com/gogo/protobuf/proto"
	"google.golang.org/grpc"
	"net"
)

type Server struct {

}

//其他服务器发送过来的中转消息
func (this *Server)Transfer(ctx context.Context, message *intercom.OneMessage )(*intercom.AckMessage,error){

	//获取到要中转消息的用户连接
	con,ok:=manage.ConManage.GetConnect(message.Receiver)
	if !ok{
		//该用户不在当前服务器，已经下线
	}
	 buf,err:=proto.Marshal(message)
	 if err!=nil{
	 	//todo log
	 }
	var reqest =&fxsrv.Request{
		Type:config.OneMessage,
		Body:buf,
		BodyLen:uint32(len(buf)),
	}
	con.Write(reqest)
	//todo
	return &intercom.AckMessage{Status:0,Rek:1},nil
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
