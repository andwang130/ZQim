package main

import (
	"logic/config"
	"logic/database"
	"logic/router"
	"logic/service"
	"time"
)

func main() {
	config.InitConfig()
	config.InitRedis()
	database.InitMysql()
	//models.InitMigrate()
	router.InitRouter()
	if err := service.Init([]string{"127.0.0.1:2379"}, time.Second*2); err != nil {
		panic(err)
	}
	go service.Regdisry.Watch()
	router.Route.Run(":8081")
}
