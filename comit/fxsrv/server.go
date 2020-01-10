package fxsrv

import (
	"fmt"
	"net"
	"strconv"
	"time"
)
var workpool *WorkPool
type service struct {
	ip string

	port uint32

	name string

	listen *net.TCPListener

    routes map[uint16]Route
	//当前连接数
	conNum uint32
	//可选项
	opts *Options
}

func (this *service)Run()error {
	var err error

	//启动workpool
	workpool=newWorkPoll(this.opts.worksize,this.opts.workchansize)
	workpool.Start()
	addr,err:=net.ResolveTCPAddr("tcp",this.ip+":"+strconv.Itoa(int(this.port)))
	if err!=nil{
		fmt.Println(err)
		return err
	}
	this.listen,err=net.ListenTCP("tcp",addr)
	if err!=nil{
		fmt.Println("Server run fail")
		fmt.Println(err)
		return err
	}
	fmt.Println(this.name+":run")
	for{
		conn,err:=this.listen.AcceptTCP()
		if err!=nil{
			fmt.Println(err)
		}
		this.setCoonBuffer(conn)
		con:=&Connect{
			conn:conn,
			Ctx:&Contex{
				values: map[string]interface{}{},
			},
			exitChan:make(chan bool),
			writeChan:make(chan *Request,10),
			routes:this.routes,
			tk:time.NewTicker(time.Duration(int64(this.opts.timeout))*time.Second),
		}
		timeout=this.opts.timeout
		if this.opts.connectCallback!=nil{
			this.opts.connectCallback(con)
		}
		go func() {
			con.work()
			if this.opts.closeCallback!=nil{
				this.opts.closeCallback(con)
			}

		}()

	}

	return nil
}
func (this *service)Name()string {

	return this.name
}
func (this *service)Init(){

}
func (this *service)AddRouter(_type uint16,handle HanleFunc)  {

	route:=this.routes[_type]
	route.handle=handle
	this.routes[_type]=route

}
func (this *service)AddMiddleware(handle HanleFunc,_types ...uint16)  {

	for _,t:=range _types{
		route:=this.routes[t]
		route.middleware=append(route.middleware,handle)
		this.routes[t]=route
	}

}
func (this *service)GetConnNum() uint32 {
	return 0
}
//设置客户端连接的缓冲区大小
func (this *service)setCoonBuffer(conn *net.TCPConn)  {

	conn.SetReadBuffer(int(this.opts.readBufMax))

	conn.SetWriteBuffer(int(this.opts.writeBufMax))
}