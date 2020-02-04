package handles

import (
	"comit/config"
	"comit/fxsrv"
	"comit/modle"
	"comit/proto/grpc"
	"errors"
	"fmt"
	"github.com/gogo/protobuf/proto"
)

func PullOneMessage(con *fxsrv.Connect,request *fxsrv.Request)error  {

    messages:=modle.GetOneMessageList(con.GetId(),1,1000)
    var pullone intercom.PullOneMessages
    for _,v:=range messages{
    	pullone.Messages=append(pullone.Messages,
    		&intercom.OneMessage{
    			Rek:v.Rek,
    			Sender:v.Sender,
    			Receiver:v.Receiver,
				Msgbody:v.Body,
				Msgtype:v.Msgtype,
				Time:v.Time,},
    		)
	}
    buf,err:=proto.Marshal(&pullone)
    if err!=nil{
    	fmt.Println(err)
    	return errors.New("proto fail")
	}
    var req fxsrv.Request
	req.Type=config.PullOneMessage
	req.Body=buf
	req.BodyLen=uint32(len(buf))
	fmt.Println(req)
    con.Write(&req)
	return nil
}
func PullGroupMessage(con *fxsrv.Connect,request *fxsrv.Request)error  {

	messages:=modle.GetGroupMessageList(con.GetId(),1,10000)
	var pullgorup intercom.PullGroupMessages
	for _,v:=range messages{

		pullgorup.Messages=append(pullgorup.Messages,&intercom.GroupMessage{
			Rek:v.GroupUserMessage.Rek,
			Sender:v.Sender,
			Groupid:v.Groupid,
			Msgtype:v.Msgtype,
			Msgbody:v.Body,
			Time:v.Time,
		})

	}
	buf,err:=proto.Marshal(&pullgorup)
	if err!=nil{
		return errors.New("proto fail")
	}
	var req fxsrv.Request
	req.Type=config.PullGorupMessage
	req.Body=buf
	req.BodyLen=uint32(len(buf))
	con.Write(&req)
	return nil
}

func PullNotifie(con *fxsrv.Connect,request *fxsrv.Request)error  {

	var notifies=modle.NotifieList(con.GetId());
	var notifiesmsg intercom.PullNotifieMessage
	var ids=make([]uint32,len(notifies))
	for i,v:=range notifies{
		notifiesmsg.Messages=append(notifiesmsg.Messages,&intercom.Notify{
			NotifieType:v.NotifieType,
			Body:v.Body,
		})
		ids[i]=v.ID
	}

	buf,err:=proto.Marshal(&notifiesmsg)
	if err!=nil{
		return errors.New("proto fail")
	}
	var req fxsrv.Request
	req.Type=config.PullNotifie
	req.Body=buf
	req.BodyLen=uint32(len(buf))
	con.Write(&req)
	if modle.DeleteNotifieList(ids)!=nil{
		//todo log
	}
	return nil
}