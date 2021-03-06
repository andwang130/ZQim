package manage

import (
	"comit/fxsrv"
	"container/heap"
	"fmt"
	"sync"
	"time"
)
var AckMange=&AckMessageManage{
	msgheap:make(MinHeap,0),
	delCh:make(chan delStruct,100),
	pushCh:make(chan *AckMessage,100),
}
type AckMessage struct {
	Body []byte //消息体
	Msgid uint64
	GropOrOne uint8
	Receiver uint32
	Timeout int64  //过期时间
	index    int
	ntime   uint8    //发送的次数

}
type AckMessageManage struct {
	rwmutex sync.RWMutex
	msgheap MinHeap
	delCh chan delStruct
	pushCh chan *AckMessage

}
type delStruct struct {
	msgid uint64
	receiver uint32
}


func (this *AckMessageManage)push(message *AckMessage) {

	message.ntime=message.ntime+1
	message.Timeout=time.Now().Unix()+5
	message.index=0
	con,ok:=ConManage.GetConnect(message.Receiver)
	if !ok{
		return
	}
	con.Ctx.Set(message.Msgid,message)
	heap.Push(&this.msgheap,message)

}
func (this *AckMessageManage)Push(message *AckMessage) {

	this.pushCh<-message
}
func (this *AckMessageManage)Delete(msgid uint64,receiver uint32) {
	this.delCh<-delStruct{
		msgid:msgid,
		receiver:receiver,
	}
}
func (this *AckMessageManage)delete(msgid uint64,receiver uint32) {
	con,ok:=ConManage.GetConnect(receiver)
	if !ok{
		return
	}
	value,ok:=con.Ctx.Get(msgid)

	if ok {
		con.Ctx.Delete(msgid)
		v,ok:=value.(*AckMessage)
		if !ok{
			return
		}
		this.msgheap.Delete(v)
	}
}
func (this *AckMessageManage)Pop()*AckMessage  {

	return heap.Pop(&this.msgheap).(*AckMessage)
}

func (this *AckMessageManage)Get(index int)*AckMessage  {

	return this.msgheap[index]
}
func (this *AckMessageManage)Len()int  {
	return this.msgheap.Len()
}
type MinHeap []*AckMessage

func (m MinHeap)Len()int  {

	return len(m)
}
func (m MinHeap)Less(i,j int)bool  {

	return m[i].Timeout<=m[j].Timeout
}
func (m MinHeap)Swap(i,j int)  {

	m[i],m[j]=m[j],m[i]
	m[i].index=i
	m[j].index=j
}
func (h *MinHeap)Push(x interface{})  {
	n:=len(*h)
	item:=x.(*AckMessage)
	item.index=n
	*h=append(*h,x.(*AckMessage))

}

func (h *MinHeap)Delete(item *AckMessage)  {
	if item.index==-1{
		return
	}
	fmt.Println("index:",item.index)
	fmt.Println(heap.Remove(h,item.index).(*AckMessage).Msgid)
}
func (h *MinHeap)Get(index int)*AckMessage  {

	old:=*h
	return old[index]
}
func (h *MinHeap)Update(item *AckMessage)  {

	heap.Fix(h,item.index)
}
func (h *MinHeap)Pop()interface{}  {
	old := *h
	n := len(old)
	x := old[n-1]
	x.index=-1
	*h = old[0 : n-1]
	return x
}


func (this *AckMessageManage)TimeLoop()  {
	t:=time.NewTicker(time.Second*1)

	for{
		select {
		case <-t.C:
			//var poplist []*AckMessage
			n:=this.Len()
			fmt.Println(this.msgheap)
			for i:=0;i<n;i++{
				if this.Get(0).Timeout<time.Now().Unix(){

					message:=AckMange.Pop()
					con,ok:=ConManage.GetConnect(message.Receiver)
					if !ok||message.ntime>3{
						AckMange.delete(message.Msgid,message.Receiver)
						//todo 连接不存在，或者重发3次都无响应，消息进入离线队列
						continue
					}


					var requests=&fxsrv.Request{
						Type:uint16(message.GropOrOne),
						Body:message.Body,
						BodyLen:uint32(len(message.Body)),
					}
					//消息重发
					if err:=con.Write(requests);err!=nil{
						continue
					}
					this.push(message)
				}else {
					break
				}
			}

			//重新入堆，等待ACK

		case delmsg:=<-this.delCh:
			this.delete(delmsg.msgid,delmsg.receiver)
		case ackmsg:=<-this.pushCh:
			this.push(ackmsg)

		}
	}
}




