package main

import (
	"comit/config"
	"comit/grpcserver"
	"comit/manage"
	"comit/registrationDiscovery"
	"comit/router"
	"github.com/sirupsen/logrus"
	"strconv"
	"time"
	"fmt"
)

func main()  {

	config.InitLog()
	go router.Run("0.0.0.0",config.ImPort,config.ServerName)
	go grpcserver.GrpcServerRun(config.GrpcIp+":"+strconv.Itoa(int(config.GrpcPort)))
	go manage.AckMange.TimeLoop()
	if err:=registrationDiscovery.Init([]string{"127.0.0.1:2379"},time.Second*2);err!=nil{
		panic(err)
	}
	if err:=registrationDiscovery.Regdisry.Registry("/root/comit/imserver/"+config.ServerName,config.ImIp+":"+strconv.Itoa(int(config.ImPort)));err!=nil{
		logrus.Error(err)
		fmt.Println(err)
	}
	if err:=registrationDiscovery.Regdisry.Registry("/root/comit/grpcserver/"+config.ServerName,config.GrpcIp+":"+strconv.Itoa(int(config.GrpcPort)));err!=nil{
		logrus.Error(err)
		fmt.Println(err)
	}
	go registrationDiscovery.Regdisry.Less()
	registrationDiscovery.Regdisry.Watch()
}