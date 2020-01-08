package ectdcofig

import (
	"context"
	"fmt"
	"go.etcd.io/etcd/clientv3"
	"time"
)

func heaerbate(leaschan <-chan *clientv3.LeaseKeepAliveResponse)  {

	for {
		select {
		case keepResp :=<-leaschan:
			if leaschan==nil{
				return
			}else{
				fmt.Println("续期",keepResp.ID)
			}
	}

	}

}
func init() {
	cli,err:=clientv3.New(
		clientv3.Config{Endpoints:[]string{"127.0.0.1:2379"},DialTimeout:time.Second*5})
	if err!=nil{
		fmt.Println("连接失败")
		return
	}
	//通过context来设置超时
	//ctx, cancel := context.WithTimeout(context.Background(),time.Second*100)

		name:="/imserver/"
		resp, err := cli.Grant(context.TODO(), 20)
		req, _ := cli.Put(context.Background(), "/root/imserver"+name, "127.0.0.1",clientv3.WithLease(resp.ID))
		keepchan,err:=cli.KeepAlive(context.Background(),resp.ID)
		if err!=nil{
			return
		}
		go heaerbate(keepchan)
		if err!=nil{
			fmt.Println(err)
			return
		}
		fmt.Println(req.PrevKv)

	for   {

		select {

		}
	}
	//cancel()

	//for _,value:=range req.Kvs{
	//	fmt.Println(string(value.Value))
	//}

}