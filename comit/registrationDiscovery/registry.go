package registrationDiscovery

import (
	"comit/config"
	"comit/manage"
	"context"
	"github.com/coreos/etcd/clientv3"
	"github.com/sirupsen/logrus"
	"strings"
	"time"
	"fmt"
)




var Regdisry RegistrationDiscovery
type RegistrationDiscovery struct {
	cli *clientv3.Client
	leaseID clientv3.LeaseID
}

func Init( endpoints []string,timeou time.Duration)error{


	cli,err:=clientv3.New(
		clientv3.Config{Endpoints:endpoints,DialTimeout:timeou})
	if err!=nil{

		return err
	}
	ctx,cancel:=context.WithTimeout(context.TODO(),timeou)
	defer cancel()
	if _,err:=cli.Status(ctx,endpoints[0]);err!=nil{
		return err
	}
	rsp,err:=cli.Grant(context.TODO(),20)
	if err!=nil{
		return err
	}
	leaseID:=rsp.ID
	Regdisry=RegistrationDiscovery{
		cli:cli,
		leaseID:leaseID,
	}

	return nil
}
func (this *RegistrationDiscovery)Registry(key string,val string)error  {



	_, err := this.cli.Put(context.Background(), key, val,clientv3.WithLease(this.leaseID))


	return err

}
func (this *RegistrationDiscovery)Less()  {
	keepchan,err:=this.cli.KeepAlive(context.Background(),this.leaseID)
	if err!=nil{
		//todo log
		return
	}
	for{
		select {
		case keepResp:=<-keepchan:
			if keepResp==nil{
				//todo log
				return
			}
		}
	}
}
func (this *RegistrationDiscovery)Watch() {

	fmt.Println("watch")
	this.GetConfig()
	imwatch := this.cli.Watch(context.Background(), "/root/comit/imserver/", clientv3.WithPrefix())
	rpcwatch := this.cli.Watch(context.Background(), "/root/comit/grpcserver/", clientv3.WithPrefix())
	for {

		select {
		case req := <-imwatch:
			for _, v := range req.Events {
				fmt.Println(v.Type)
			}
		case req := <-rpcwatch:
			for _, v := range req.Events {
				var key=strings.TrimPrefix(string(v.Kv.Key),"/root/comit/grpcserver/")
				var value=string(v.Kv.Value)
				if key==config.ServerName{
					continue
				}
				if v.Type.String()=="PUT"{
					if err:=manage.ComitManage.AddComitServer(key, value);err!=nil{

						logrus.Error(err)
					}
				}
				if v.Type.String()=="DELETE"{

					manage.ComitManage.DeleteComitServer(key)
				}
			}

		}
	}

}
func (this *RegistrationDiscovery)GetConfig(){


	rsp,err:=this.cli.Get(context.Background(),"/root/comit/grpcserver/", clientv3.WithPrefix(),
	)
	if err!=nil{
		fmt.Println(err)
		return
	}
	for _,v:=range rsp.Kvs{
		key:=strings.TrimPrefix(string(v.Key),"/root/comit/grpcserver/")
		value:=v.Value
		if key!=config.ServerName {
			err:=manage.ComitManage.AddComitServer(key, string(value))
			if err != nil {
				fmt.Println(err)
				//todo log
			}
		}
	}

}
