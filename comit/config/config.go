package config


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