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
	AckManyMessage //多Ack
	Ping          //心跳
	PullOneMessage   //拉取单聊消息
	PullGorupMessage  //拉取群聊消息
	DeleteManyMesage    //离线消息删除多个
	FriendNotice   //添加好友通知消息
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