package main

import (
	"errors"
	"fmt"
	"fxsrv"
	"net/http"
	_ "net/http/pprof"

)

type Manmage struct {
	conns map[uint32]*fxsrv.Connect

}

func (this *Manmage)AddConn()  {

}
func (this *Manmage)Reduce(key uint32)  {

	delete(this.conns,key)

}

func coonectHandle(con *fxsrv.Connect)  {
     fmt.Println("一个连接建立")
}
func CloseHandle(con *fxsrv.Connect)  {
	fmt.Println("一个连接关闭")
}
func authhandle(con *fxsrv.Connect,request *fxsrv.Request)error  {
	fmt.Println("authhandle")
	con.Ctx.Set("auth",123456)

	return nil
}
func TestHandle1(con *fxsrv.Connect,request *fxsrv.Request)error  {
	fmt.Println("TestHandle1")

	return nil
}
func TestMiddleware1(con *fxsrv.Connect,request *fxsrv.Request)error  {
	fmt.Println("TestMiddleware1")
	if _,ok:=con.Ctx.Get("auth");!ok{
		return errors.New("not auth")
	}else{

		var req fxsrv.Request
		req.Type=1
		req.Flag=10
		req.Body=[]byte{1,2,3,4,5,6,97}
		req.BodyLen=uint32(len(req.Body))
		con.Write(&req)
		fmt.Println(v)
	}
	return nil
}
func TestMiddleware2(con *fxsrv.Connect,request *fxsrv.Request)error  {
	fmt.Println("TestMiddleware2")
	if v,ok:=con.Ctx.Get("id");!ok{
		return errors.New("not auth")
	}else{
		fmt.Println(v)
	}
	return nil
}
func main()  {
	server:=fxsrv.NewServer("192.168.0.106",8080,"server",
	fxsrv.SetConnectCallback(coonectHandle),
	fxsrv.SetCloseCallback(CloseHandle),
	fxsrv.SetreadBufMax(10240),
	fxsrv.SetwriteBufMax(10240),
	fxsrv.Settimeout(60),
	fxsrv.SetWorkChanSize(1000),
	fxsrv.SetWorkSize(1000),
	)


	server.AddRouter(2,authhandle)
	server.AddRouter(1,TestHandle1)
	server.AddMiddleware(TestMiddleware1,1)
	server.AddMiddleware(TestMiddleware2,1)
	go http.ListenAndServe("localhost:10000",nil)

	server.Run()
}