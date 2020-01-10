package main

import (
	"comit/config"
	"comit/grpcserver"
	"comit/registrationDiscovery"
	"comit/router"
	"strconv"
	"time"
	"fmt"
)

func main()  {


	go router.Run(config.Addr,config.Port,config.ServerName)
	go grpcserver.GrpcServerRun(config.Grpcaddr)
	if err:=registrationDiscovery.Init([]string{"127.0.0.1:2379"},time.Second*2);err!=nil{
		panic(err)
	}
	if err:=registrationDiscovery.Regdisry.Registry("/root/comit/imserver/"+config.ServerName,config.Addr+strconv.Itoa(config.Port));err!=nil{
		fmt.Println(err)
	}
	if err:=registrationDiscovery.Regdisry.Registry("/root/comit/grpcserver/"+config.ServerName,config.Grpcaddr);err!=nil{
		fmt.Println(err)
	}
	go registrationDiscovery.Regdisry.Less()
	registrationDiscovery.Regdisry.Watch()
}