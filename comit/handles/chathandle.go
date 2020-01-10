package handles

import (
	"comit/manage"
	"comit/fxsrv"
	"comit/proto"
	"errors"
	"fmt"
	"github.com/golang/protobuf/proto"
)

func OneMessageHandle(con *fxsrv.Connect,request *fxsrv.Request)error  {

	var msg message.OneMessage
	if proto.Unmarshal(request.Body,&msg)!=nil{
		return errors.New("message error")
	}
	if msg.Sender!=con.GetId(){
		return errors.New("id不一致")
	}
	receiver,ok:= manage.ConManage.GetConnect(msg.Receiver)
	if !ok{
		//该用户未连接到本地，获取该用户连接的服务器
		fmt.Println("用户未登录")
		//todo 进入离线消息

	}else{
		receiver.Write(request)
	}

	return nil
}

func GorupMessageHandle(con *fxsrv.Connect,request *fxsrv.Request)error  {

	return nil
}

//ack消息
func AckMesageHandle(con *fxsrv.Connect,request *fxsrv.Request) error {
	var ackmeesage message.AckMessage
	err:=proto.Unmarshal(request.Body,&ackmeesage)
	//ack消息失败，不做处理，等待ACK再次重发
	if err!=nil{
		return nil
	}
	//删除ack消息
	manage.AckMange.Delete(ackmeesage.Rek)
	return nil
}

