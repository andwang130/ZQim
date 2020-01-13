package manage

import (
	"fmt"
	"testing"
	"time"
)

func TestAckHeap(t *testing.T)  {
	var mange=&AckMessageManage{
		msgheap:make(MinHeap,0),
		messages:make(map[uint64]*AckMessage)}
	var ackmessage1=&AckMessage{
		Msgid:1,
		Receiver:1,
		Timeout:7,
	}
	var ackmessage2=&AckMessage{
		Msgid:2,
		Receiver:2,
		Timeout:8,
	}
	var ackmessage3=&AckMessage{
		Msgid:3,
		Receiver:3,
		Timeout:9,
	}
	var ackmessage4=&AckMessage{
		Msgid:4,
		Receiver:4,
		Timeout:11,
	}
	var ackmessage5=&AckMessage{
		Msgid:5,
		Receiver:5,
		Timeout:15,
	}
	var ackmessage6=&AckMessage{
		Msgid:6,
		Receiver:6,
		Timeout:time.Now().Unix(),
	}
	mange.Push(ackmessage2)

	mange.Push(ackmessage1)

	mange.Push(ackmessage4)

	mange.Push(ackmessage3)
	mange.Push(ackmessage6)
	mange.Push(ackmessage5)

	//mange.Delete(1)
	//
	//mange.Delete(2)
	n:=mange.Len()
	//ackmessage2.timeout=125
	//h.Update(ackmessage2)
	for i:=0;i<n;i++{
		message:=mange.Pop()
		mange.Push(message)
		//h[i].timeout=time.Now().Unix()+int64(rand.Intn(500))
		//h.Update(h[i])
	}
	for i:=0;i<mange.Len();i++{
		fmt.Println(mange.Get(i))
	}
	//for i:=0;i<n;i++{
	//
	//	fmt.Println(h[i])
	//}

}
