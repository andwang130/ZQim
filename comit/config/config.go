package config


const ServerName string="im2"
const Addr="127.0.0.1"
const Port=8555
const Grpcaddr=Addr+":8666"

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