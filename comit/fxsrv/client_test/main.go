package main

import (
	"fmt"
	"fxsrv"
	"net"
	"sync"
	"time"
)

func clientTest()  {
	client, err := net.Dial("tcp", "192.168.0.106:8080")
	if err != nil {
		panic(err)
	}
	var body=make([]byte,1024)
	for i:=0;i<1024;i++{
		body[i]=1
	}
	var buf= body
	var req fxsrv.Request
	req.Type = 2
	req.Flag = 1
	req.Body = buf
	req.BodyLen = uint32(len(buf))
	client.Write(req.GetBytes())
	req.Type = 1
	for i := 0; i < 2000; i++ {
		//time.Sleep(time.Duration(rand.Intn(10))*time.Second)
		time.Sleep(time.Millisecond*1000)
		_, err = client.Write(req.GetBytes())
		if err != nil {
			fmt.Println(err)
			return
		}
		var b = make([]byte, 1024)
		client.Read(b)
	}
}



func main() {
	var wait sync.WaitGroup
	var nowtime=time.Now().Unix()
	for i := 0; i < 10000; i++ {
		fmt.Println(i)
		time.Sleep(time.Millisecond*2)
		go func() {
			wait.Add(1)
			clientTest()
			wait.Done()
		}()

	}
	wait.Wait()
	fmt.Println(time.Now().Unix()-nowtime)
}
