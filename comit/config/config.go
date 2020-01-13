package config

import "time"

const ServerName string="im2"
const Addr="127.0.0.1"
const Port=8777
const Grpcaddr=Addr+":8999"

const GrpcTimeOut  =time.Second*5
const (

	Auth=iota+1  //认证
	OneMessage    //单聊消息
	GorupMessage  //群聊消息
	AckMesage     //Ack
	Ping          //心跳
	PullOneMessage   //拉取单聊消息
	PullGorupMessage  //拉取群聊消息
	AckMesageMany     //Ack多个
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