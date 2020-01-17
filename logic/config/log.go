package config

import (
	uuid "github.com/satori/go.uuid"
	log "github.com/sirupsen/logrus"
	hook "logic/pkg/log"
	"os"
	"time"
)

func InitLog() {
	uuids := uuid.NewV1()
	log.AddHook(hook.NewTraceIdHook(uuids.String() +" "))
	timeStr:=time.Now().Format("2006-01-02")
	file, _ := os.OpenFile("log/"+timeStr+".log", os.O_CREATE|os.O_WRONLY, 0666)
	log.SetOutput(file)
	//设置最低loglevel
	log.SetLevel(log.InfoLevel)
}
