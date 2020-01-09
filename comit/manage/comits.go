package manage

import (
	"comit/proto/grpc"
	"context"
	"fmt"
	"google.golang.org/grpc"
	"sync"
	"time"
)

var ComitManage ComitManages
type ComitGrpcServer struct {

	client intercom.GreeterClient
}
type ComitManages struct {
	rwmutex sync.RWMutex
	comits map[string]*ComitGrpcServer
}
func (this *ComitManages)AddComitServer(key,addr string)error  {

	grpcserver, err := NewComitServer(addr)
	if err != nil {
		fmt.Println(err)
		return err
		//todo log
	}
	this.rwmutex.Lock()
	fmt.Println("添加一个rpc服务:",key,"ip:",addr)
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

	client:=intercom.NewGreeterClient(con)
	comitserver.client=client
	return comitserver,nil

}
func init()  {
	ComitManage.comits=make(map[string]*ComitGrpcServer)
}