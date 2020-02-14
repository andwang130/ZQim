package config

import (
	"os"
	"time"
	"github.com/spf13/viper"
	"github.com/sirupsen/logrus"
	uuid "github.com/satori/go.uuid"
)

var ServerName string;
var ImIp string
var ImPort uint32
var GrpcIp string
var GrpcPort uint32

const GrpcTimeOut  =time.Second*5
const (

	Auth=iota+1  //认证
	OneMessage    //单聊消息
	GorupMessage  //群聊消息
	AckMesage     //Ack
	AckManyMessage //多Ack
	Ping          //心跳
	PullOneMessage   //拉取单聊消息
	PullGorupMessage  //拉取群聊消息
	PullNotifie   //拉取通知
	DeleteManyMesage    //离线消息删除多个
	FriendNotife//添加好友通知消息
	FriendAgree //同意通知。发起方收到
)
//auth状态码
const(
	//成功
	AuthSuccess=iota
	//token错误
	Tokenerror
	//token超时
	TokenOvertime
	AuthOthe
	//protobuf解析错误
	MessagError
)
const(
	AckSuccess=iota
	AckSaveFail
)
func init()  {

	path, err := os.Getwd()
	if err != nil {
		panic(err)
	}
	viper.AddConfigPath(path + "/config")
	viper.SetConfigName("config")
	viper.SetConfigType("yaml")
	if err := viper.ReadInConfig(); err != nil {
		panic(err)
	}
	ServerName=viper.GetString("imserver.servername")
	ImIp=viper.GetString("imserver.ip")
	ImPort=viper.GetUint32("imserver.port")
	GrpcIp=viper.GetString("grpcserver.ip")
	GrpcPort=viper.GetUint32("grpcserver.port")

}
func InitLog() {
	uuids := uuid.NewV1()
	logrus.AddHook(NewTraceIdHook(uuids.String() +" "))
	timeStr:=time.Now().Format("2006-01-02")
	file, _ := os.OpenFile("log/"+timeStr+".log", os.O_CREATE|os.O_WRONLY, 0666)
	logrus.SetOutput(file)
	//设置最低loglevel
	logrus.SetLevel(logrus.InfoLevel)
}
type TraceIdHook struct {
	TraceId  string
}

func NewTraceIdHook(traceId string) logrus.Hook {
	hook := TraceIdHook{
		TraceId:  traceId,
	}
	return &hook
}

func (hook *TraceIdHook) Fire(entry *logrus.Entry) error {
	entry.Data["traceId"] = hook.TraceId
	return nil
}

func (hook *TraceIdHook) Levels() []logrus.Level {
	return logrus.AllLevels
}