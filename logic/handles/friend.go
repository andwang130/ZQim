package handles

import (
	"context"
	"github.com/gin-gonic/gin"
	"logic/cache"
	"logic/config"
	"logic/manage"
	"logic/models"
	"logic/proto"
)

type AddFriendParm struct {
	FriendID uint32 `json:"friendid" form:"friendid" binding"required"`
	Greet   string `json:"greet" form:"greet" binding:"required"`
}
//添加好友
func AddFriend(c *gin.Context)  {
	var parm AddFriendParm
	if err:=c.ShouldBind(&parm);err!=nil{
		ParmError(c,err.Error())
		return
	}
	var _,uid=getuidAndusername(c)

	if uid==parm.FriendID{
		ParmError(c,"can not self")
	}
	if models.FirendQuery(uid,parm.FriendID){
		//已经是好友关系了
		ParmError(c,"Already a friend")
		return
	}
	if models.NotifyQuery(uid,parm.FriendID){
		ParmError(c,"repeat")
		return
	}
	var nid uint32
	var err error
	if nid,err=models.NotifyCreate(uid,parm.FriendID,parm.Greet);err!=nil{
		//todo 数据库失败，写入日志
		DBerror(c)
		return
	}
	//todo 向链接服务器发送一个推送，让用户有拉取好友添加请求
	user,err:=rediscache.GetUser(parm.FriendID)
	if err==nil{
		gcleint,ok:=manage.ComitManage.GetComitServer(user.Srvname)
		if ok{

			ctx,cancle:=context.WithTimeout(context.TODO(),config.RgpcTimeOut)
			defer cancle()
			gcleint.Client.FriendNotify(ctx,&intercom.Notify{
				Nid:nid,
				Receiver:parm.FriendID,
			})
		}
	}

	Success(c,nil)
}

type AgreeParm struct {
	NotifyID uint32 `json:"notify_id" form:"notify_id"`
}
func Agree(c *gin.Context)  {
	var parm AgreeParm
	if err:=c.ShouldBind(&parm);err!=nil{
		ParmError(c,err.Error())
		return
	}
	var _,uid=getuidAndusername(c)
 	notify,err:=models.NotifyFirst(uid,parm.NotifyID,1)
 	if err!=nil||notify.ID==0{
		ParmError(c,"Nonexistent notify_id")
 		return
	}
	if models.FriendAdd(notify.Sender,notify.Receive,notify.ID)!=nil{
		//todo 数据库失败，写入日志
		DBerror(c)
		return
	}
 	//todo 添加好友成功，发送一条推送信息
	user,err:=rediscache.GetUser(notify.Sender)
	if err==nil{
		gcleint,ok:=manage.ComitManage.GetComitServer(user.Srvname)
		if ok{

			ctx,cancle:=context.WithTimeout(context.TODO(),config.RgpcTimeOut)
			defer cancle()
			gcleint.Client.FriendAgree(ctx,&intercom.Agree{
				Greet:notify.Greet,
				Nid:notify.ID,
				Uid:notify.Sender,
				Receiver:notify.Receive,
			})
		}
	}
 	Success(c,notify.ID)
}
//拒绝好友请求
func Refuse(c *gin.Context)  {
	var parm AgreeParm
	if err:=c.ShouldBind(&parm);err!=nil{
		ParmError(c,err.Error())
	}
	var _,uid=getuidAndusername(c)
	notify,err:=models.NotifyFirst(uid,parm.NotifyID,1)
	if err!=nil||notify.ID==0{
		ParmError(c,"Nonexistent notify_id")
		return
	}
	if models.NotifyUpdateStatus(notify.ID,3)!=nil{
		//todo 写日志
		DBerror(c)
		return
	}
	Success(c,notify.ID)

}
type DeleteFirendparm struct {
	FriendID uint32 `json:"friendid" binding:"required" form:"friendid"`
}
//删除好友
func DeleteFirend(c *gin.Context){

	var parm DeleteFirendparm
	if err:=c.ShouldBind(&parm);err!=nil{
		ParmError(c,err.Error())
		return
	}
	var _,uid=getuidAndusername(c)
	if models.FriendDelete(uid,parm.FriendID)!=nil{
		DBerror(c)
		return
	}

	Success(c,nil)
}

func FirendList(c *gin.Context)  {

	var _,uid=getuidAndusername(c)
	var Relust=models.FirendList(uid)

	Success(c,&Relust)

}