package manage

import (
	"container/heap"
	"fmt"
	"testing"
	"time"
)

func TestAckHeap(t *testing.T)  {
	h:=make(MinHeap,0)
	heap.Init(&h)
	var ackmessage1=&AckMessage{
		Receiver:1,
		Timeout:time.Now().Unix(),
	}
	var ackmessage2=&AckMessage{
		Receiver:2,
		Timeout:time.Now().Unix(),
	}
	var ackmessage3=&AckMessage{
		Receiver:3,
		Timeout:time.Now().Unix(),
	}
	var ackmessage4=&AckMessage{
		Receiver:4,
		Timeout:time.Now().Unix(),
	}
	var ackmessage5=&AckMessage{
		Receiver:5,
		Timeout:time.Now().Unix(),
	}
	var ackmessage6=&AckMessage{
		Receiver:6,
		Timeout:time.Now().Unix(),
	}
	heap.Push(&h,ackmessage2)

	heap.Push(&h,ackmessage1)

	heap.Push(&h,ackmessage4)

	heap.Push(&h,ackmessage3)
	heap.Push(&h,ackmessage6)
	heap.Push(&h,ackmessage5)

	h.Delete(ackmessage1)

	h.Delete(ackmessage1)
	n:=h.Len()
	//ackmessage2.timeout=125
	//h.Update(ackmessage2)
	for i:=0;i<n;i++{
		fmt.Println(h[i])
		//h[i].timeout=time.Now().Unix()+int64(rand.Intn(500))
		//h.Update(h[i])
	}
	//for i:=0;i<n;i++{
	//
	//	fmt.Println(h[i])
	//}

}
