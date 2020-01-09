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

func AckMesageHandle(con *fxsrv.Connect,request *fxsrv.Request) error {
	return nil
}

