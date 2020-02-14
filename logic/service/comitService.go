package service

import (
	"context"
	"fmt"
	"google.golang.org/grpc"
	"logic/pkg/proto"
	"math/rand"
	"sync"
	"sync/atomic"
	"time"
)

var ComitManage ComitManages
type ComitGrpcServer struct {
	Client intercom.GreeterClient
}
type ComitManages struct {
	rwmutex sync.RWMutex
	comits map[string]*ComitGrpcServer
	tcpserver []string
	index uint32
}
func (this *ComitManages)AddComitServer(key,addr string)error  {

	fmt.Println("添加一个rpc服务:",key,"ip:",addr)
	grpcserver, err := NewComitServer(addr)
	if err != nil {
		fmt.Println(err)
		return err
		//todo log
	}
	this.rwmutex.Lock()

	defer this.rwmutex.Unlock()
	this.comits[key]=grpcserver
	return nil
}
func (this *ComitManages)DeleteComitServer(key string)  {
	fmt.Println(key,":rpc服务下线了")
	this.rwmutex.Lock()
	defer this.rwmutex.Unlock()
	delete(this.comits,key)
}
func (this *ComitManages)GetComitServer(key string)(*ComitGrpcServer,bool) {
	this.rwmutex.RLock()
	defer this.rwmutex.RUnlock()
	v,ok:=this.comits[key]
	return v,ok
}
func (this *ComitManages)RandComitServer()*ComitGrpcServer {


	this.rwmutex.RLock()
	defer this.rwmutex.RUnlock()
	var srv *ComitGrpcServer
	rand.Seed(time.Now().UnixNano())
	var n=rand.Intn(len(this.comits))
	var i=0;
	for _,v:=range this.comits{
		srv=v
		if i==n{
			break
		}
		i++
	}
	return srv


}
func NewComitServer(addr string)(*ComitGrpcServer,error)  {
	var comitserver =&ComitGrpcServer{}
	ctx, cancel:=context.WithTimeout(context.TODO(),time.Second*5)
	defer cancel()
	con,err:=grpc.DialContext(ctx,addr,
		grpc.WithInsecure(),
		grpc.WithBlock(),
		)
	if err!=nil{
		fmt.Println(err)
		return comitserver,err
	}

	client:= intercom.NewGreeterClient(con)
	comitserver.Client=client
	return comitserver,nil

}
func (this *ComitManages)AddTcpServer(ip string)  {

	fmt.Println("增加一个连接服务器：",ip)
	this.rwmutex.Lock()
	defer this.rwmutex.Unlock()
	this.tcpserver=append(this.tcpserver,ip)
}
func (this *ComitManages)NextTcpServer()string  {
	this.rwmutex.RLock()
	defer this.rwmutex.RUnlock()
	atomic.AddUint32(&this.index,1)
	return this.tcpserver[this.index%uint32(len(this.tcpserver))]
}
func (this *ComitManages)DeleteTcpServer(ip string) {
	fmt.Println("删除一个连接服务器：",ip)
	this.rwmutex.Lock()
	defer this.rwmutex.Unlock()
	for index,v:=range this.tcpserver{
		if v==ip{
			this.tcpserver=append(this.tcpserver[:index],this.tcpserver[index+1:]...)
			return
		}
	}
}
func init()  {
	ComitManage.comits=make(map[string]*ComitGrpcServer)
}