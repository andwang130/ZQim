package ectdcofig

import (
	"context"
	"fmt"
	"go.etcd.io/etcd/clientv3"
	"time"
)

func martrsTest()  {

	cli,err:=clientv3.New(
		clientv3.Config{Endpoints:[]string{"127.0.0.1:2379"},DialTimeout:time.Second*5})
	if err!=nil{
		return
	}

	for {
		watch:=cli.Watch(context.Background(), "/root/imserver/",clientv3.WithPrefix())
		for wres:=range watch{
			for _,ev:=range wres.Events{
				fmt.Println(ev.Type)
				fmt.Println(string(ev.Kv.Key),string(ev.Kv.Value))

			}
		}
	}
}
func main()  {

	martrsTest()
}
