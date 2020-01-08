package router

import (
	"comit/fxsrv"
	"comit/handles"
)

const (
	Auth=iota+1
	OneMessage
	GorupMessage
	AckMesage


)

var server fxsrv.Server
func init()  {
	server=fxsrv.NewServer("127.0.0.1",8089,"server")

	server.AddRouter(OneMessage,handles.OneMessageHandle)

	server.AddRouter(GorupMessage,handles.GorupMessageHandle)

	server.AddRouter(AckMesage,handles.AckMesageHandle)
}
