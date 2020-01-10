package manage

import (
	"comit/config"
	"comit/fxsrv"
	"container/heap"
	"sync"
	"time"
)
var AckMange=&AckMessageManage{
	msgheap:make(MinHeap,0),
	messages:make(map[uint32]*AckMessage),
}
type AckMessage struct {
	body []byte //消息体
	msgid uint64
	receiver uint32
	timeout int64  //过期时间
	index    int
	ntime   uint8    //发送的次数
}
type AckMessageManage struct {
	messages map[uint64]*AckMessage
	rwmutex sync.RWMutex
	msgheap MinHeap

}

func (this *AckMessageManage)Push(message *AckMessage) {

	heap.Push(&this.msgheap,message)
	this.messages[message.msgid]=message


}
func (this *AckMessageManage)Delete(msgid uint64) {
	item,ok:=this.messages[msgid]
	if ok{

		this.msgheap.Delete(item)
	}
}
func (this *AckMessageManage)Pop()*AckMessage  {

	return heap.Pop(&this.msgheap).(*AckMessage)
}


type MinHeap []*AckMessage

func (m MinHeap)Len()int  {

	return len(m)
}
func (m MinHeap)Less(i,j int)bool  {

	return m[i].timeout<=m[j].timeout
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
	heap.Remove(h,item.index)
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


func TimeLoop()  {
	t:=time.NewTicker(time.Second*1)

	for{
		select {
		case <-t.C:
			n:=len(AckMange.msgheap)
			var poplist []*AckMessage
			for i:=0;i<n;i++{
				if AckMange.msgheap[i].timeout<time.Now().Unix(){
					message:=AckMange.Pop()
					con,ok:=ConManage.GetConnect(message.receiver)
					if !ok||message.ntime>3{
						AckMange.Delete(message.msgid)
						//todo 连接不存在，或者重发3次都无响应，消息进入离线队列
						continue
					}
					poplist=append(poplist,message)

					var requests=&fxsrv.Request{
						Type:config.OneMessage,
						Body:message.body,
						BodyLen:uint32(len(message.body)),
					}
					//消息重发
					con.Write(requests)
					message.ntime=message.ntime+1
				}
			}
			//重新入堆，等待ACK
			for _,v:=range poplist{
				AckMange.Push(v)
			}
		}
	}
}




