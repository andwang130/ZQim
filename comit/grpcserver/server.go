package grpcserver

import (
	"comit/proto/grpc"
	"context"
	"google.golang.org/grpc"
	"net"
)

type Server struct {

}

func (this *Server)Transfer(ctx context.Context, message *intercom.OneMessage )(*intercom.AckMessage,error){


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
