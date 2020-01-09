package manage

import (
	"comit/fxsrv"
	"fmt"
	"sync"
)

type ConnectManage struct {
	cons map[uint32]*fxsrv.Connect
	rwmutex sync.RWMutex
}
func (this *ConnectManage)AddConnect(uid uint32,con *fxsrv.Connect) {
	this.rwmutex.Lock()
	fmt.Println("添加连接")
	defer this.rwmutex.Unlock()
	this.cons[uid]=con
}
func (this *ConnectManage)GetConnect(uid uint32)(*fxsrv.Connect,bool)  {

	this.rwmutex.RLock()
	defer this.rwmutex.RUnlock()
	con,ok:=this.cons[uid]
	return con,ok
}
func (this *ConnectManage)DeleteConnect(uid uint32)  {
	this.rwmutex.Lock()
	fmt.Println("删除连接")
	defer this.rwmutex.Unlock()
	delete(this.cons,uid)
}
func (this *ConnectManage)CleanConnect()  {

	this.rwmutex.Lock()
	defer this.rwmutex.Unlock()
	for k,_:=range this.cons{
		delete(this.cons,k)
	}
}

var ConManage ConnectManage
func init()  {
	ConManage.cons=make(map[uint32]*fxsrv.Connect)
}