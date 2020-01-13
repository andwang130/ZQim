package config

import "time"

const ServerName string="im2"
const Addr="127.0.0.1"
const Port=8777
const Grpcaddr=Addr+":8999"

const GrpcTimeOut  =time.Second*5
const (
	Auth=iota+1
	OneMessage
	GorupMessage
	AckMesage
	Ping
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