package main

import (
	"logic/registrationDiscovery"
	"logic/router"
	"time"

	//_ "logic/ectdcofig"
)
func main() {

	if err:=registrationDiscovery.Init([]string{"127.0.0.1:2379"},time.Second*2);err!=nil{
		panic(err)
	}
	go registrationDiscovery.Regdisry.Watch()
	router.Route.Run("0.0.0.0:8080")
}
