package fxsrv

import (
	"bytes"
	"encoding/binary"
	"errors"
	"fmt"
	"github.com/sirupsen/logrus"
	"net"
	"sync"
	"sync/atomic"
	"time"
)
var ConnectIsCloseError=errors.New("ConnectIsClosed")
var WriteblockError=errors.New("writeChanisblock")
var requstPool=sync.Pool{
	New: func() interface{} {
		return new(Request)
	},
}
var timeout int64=100
type Connect struct {
	id uint32
	conn *net.TCPConn
	routes map[uint16]Route
	buff bytes.Buffer
	Ctx  *Contex
	exitChan chan bool
	writeChan chan *Request
	heartTime int64
	isClose  int32
	tk  *time.Ticker
	auth bool
}

func (this *Connect)work(){
	go this.writeLoop()
	this.read()
}

func (this *Connect)read(){
	
	var buf=make([]byte,10240)
	for{
		n,err:=this.conn.Read(buf)
		if err!=nil{
			fmt.Println(err)
			this.Close()
			return
		}
		this.buff.Write(buf[0:n])
		this.unpack()
	}

}
func (this *Connect)unpack()  {

	for {
		if this.buff.Len() < 5 {
			break
		}
		byts := this.buff.Bytes()
		var bodylen uint32
		buf := bytes.NewBuffer(byts[2:6])
		binary.Read(buf, binary.BigEndian, &bodylen)

		if this.buff.Len()-5 < int(bodylen) {
			break
		}
		var request =requstPool.Get().(*Request)
		//var request=new(Request)
		request.BodyLen = bodylen
		buf = bytes.NewBuffer(byts[0:2])
		binary.Read(buf, binary.BigEndian, &request.Type)

		buf = bytes.NewBuffer(byts[6:7])
		binary.Read(buf, binary.BigEndian, &request.Flag)
		request.Body = byts[7 : bodylen+7]
		this.buff.Next(int(7 + bodylen))
		this.routesRun(request)
	}
}
func (this *Connect)Write(request *Request)error{

	if this.IsClose(){

		return ConnectIsCloseError
	}

	select {

	//如果连接关闭，exitChan将相应，不会阻塞writeChan
	case  <-this.exitChan :
		return ConnectIsCloseError
	case this.writeChan<-request:
		return nil
	default:
		fmt.Println("阻塞了")
		return WriteblockError
	}




}

func (this *Connect)writeLoop(){
	defer this.tk.Stop()
	for {
		select {
		case <-this.exitChan:
				return

		case req := <-this.writeChan:
			if req!=nil {
				_, err := this.conn.Write(req.GetBytes())
				if err != nil {
					return
				}
			}
		case n:=<-this.tk.C:
			if n.Unix()-timeout>this.heartTime{

				this.Close()
				return
			}
		}
	}



}
func (this *Connect)Close() {
	if atomic.CompareAndSwapInt32(&this.isClose,0,1){
		this.conn.Close()
		close(this.exitChan)
		close(this.writeChan)
	}
}

func (this *Connect)IsClose()bool  {

	return  atomic.LoadInt32(&this.isClose)==1;
}

func (this *Connect)routesRun(req *Request){

	workpool.AddWrok(
		func() {
			route,ok:=this.routes[req.Type]
			if ok{
				for _,h:=range route.middleware{
					if err:=h(this,req);err!=nil{
						logrus.Error(err)
						return
					}
				}

				if route.handle!=nil{
					err:=route.handle(this,req)
					if err!=nil{
						logrus.Error(err)
						fmt.Println(err.Error())
					}
				}
				//

			}
			defer requstPool.Put(req)
		})


}

func (this *Connect)SetheartTime(nowtime int64)  {
	this.heartTime=nowtime
}
func (this *Connect)SetAuth(status bool)  {

	this.auth=status
}
func (this *Connect)IsAuth()bool  {

	return this.auth
}
func (this *Connect)SetId(id uint32)  {

	this.id=id
}
func (this *Connect)GetId()uint32  {

	return this.id
}
//func (this *Connect)  {
//	this.conn.RemoteAddr()
//}