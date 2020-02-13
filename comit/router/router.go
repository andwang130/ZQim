package router

import (
	"comit/config"
	"comit/manage"
	"comit/fxsrv"
	"comit/handles"
	"comit/middlehandles"
	"comit/rediscache"
	"fmt"
)

var server fxsrv.Server
func setRouter()  {

	server.AddRouter(config.OneMessage,handles.OneMessageHandle)

	server.AddRouter(config.GorupMessage,handles.GorupMessageHandle)

	server.AddRouter(config.AckMesage,handles.AckMesageHandle)

	server.AddRouter(config.Auth,handles.AuthHandle)
	server.AddRouter(config.Ping,handles.PingHandle)
	server.AddRouter(config.PullOneMessage,handles.PullOneMessage)
	server.AddRouter(config.PullGorupMessage,handles.PullGroupMessage)
	server.AddRouter(config.DeleteManyMesage,handles.DeleteManyHandle)
	server.AddRouter(config.PullNotifie,handles.PullNotifie)
	server.AddMiddleware(middlehandles.AuthMiddleHandle,config.PullNotifie,config.OneMessage,config.GorupMessage,config.AckMesage,config.Ping)
}
func Run(addr string,port uint32,name string)  {
	server=fxsrv.NewServer(addr,port,name,
		fxsrv.SetConnectCallback(coonectHandle),
		fxsrv.SetCloseCallback(CloseHandle),
		fxsrv.SetWorkSize(100),
		fxsrv.SetWorkChanSize(100),
		)
	setRouter()
	server.Run()

}
func coonectHandle(con *fxsrv.Connect)  {

	fmt.Println(con.GetId())
}
func CloseHandle(con *fxsrv.Connect)  {
	manage.ConManage.DeleteConnect(con.GetId())
	rediscache.DeleteUser(con.GetId())
}