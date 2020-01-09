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

func GrpcServerInit()  {

	lic,err:=net.Listen("tcp","127.0.0.1")
	if err!=nil{
		panic(err)
	}
	s:=grpc.NewServer()
	intercom.RegisterGreeterServer(s,&Server{})
	s.Serve(lic)
}