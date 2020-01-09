package router

import (
	"comit/config"
	"comit/manage"
	"comit/fxsrv"
	"comit/handles"
	"comit/middlehandles"
)

var Server fxsrv.Server
func init()  {
	Server=fxsrv.NewServer("127.0.0.1",8089,"server",
	fxsrv.SetConnectCallback(coonectHandle),
	fxsrv.SetCloseCallback(CloseHandle),
	)
	Server.AddRouter(config.OneMessage,handles.OneMessageHandle)

	Server.AddRouter(config.GorupMessage,handles.GorupMessageHandle)

	Server.AddRouter(config.AckMesage,handles.AckMesageHandle)

	Server.AddRouter(config.Auth,handles.AuthHandle)

	Server.AddMiddleware(middlehandles.AuthMiddleHandle,config.OneMessage,config.GorupMessage,config.AckMesage,config.Ping)
}
func coonectHandle(con *fxsrv.Connect)  {

}
func CloseHandle(con *fxsrv.Connect)  {
	manage.ConManage.DeleteConnect(con.GetId())
}