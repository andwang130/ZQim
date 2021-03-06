package controller

import (
	"context"
	"errors"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
	"logic/config"
	"logic/models"
	"logic/pkg/proto"
	"logic/service"
	"logic/utils"
)

type AddFriendParm struct {
	FriendID uint32 `json:"friendid" form:"friendid" binding"required"`
	Greet   string `json:"greet" form:"greet" binding:"required"`
}
//添加好友
func AddFriend(c *gin.Context)  {
	var parm AddFriendParm
	if err:=c.ShouldBind(&parm);err!=nil{
		utils.ResponseError(c,500,err)
		return
	}
	var _,uid= models.GetuidAndusername(c)

	if uid==parm.FriendID{
		utils.ResponseError(c,20002,errors.New("can not self"))
		return
	}
	if models.FirendQuery(uid,parm.FriendID){
		//已经是好友关系了
		utils.ResponseError(c,20003,errors.New("Already a friend"))
		return
	}
	if models.NotifyQuery(uid,parm.FriendID){
		utils.ResponseError(c,20004,errors.New("repeatd"))
		return
	}
	var nid uint32
	var err error
	if nid,err=models.NotifyCreate(uid,parm.FriendID,parm.Greet);err!=nil{
		logrus.Info(err)
		utils.DBerror(c)
		return
	}
	//todo 向链接服务器发送一个推送，让用户有拉取好友添加请求
	user,err:=config.GetUserFromRedis(parm.FriendID)
	fmt.Println(user)
	if user.Uid!=0{
		gcleint,ok:=service.ComitManage.GetComitServer(user.Srvname)
		if ok{
			print("FriendNotify")
			var notife =&intercom.FriendNotife{
				Greet:parm.Greet,
				Nid:nid,
				Uid:uid,
				Receiver:parm.FriendID,
			}

				ctx, cancle := context.WithTimeout(context.TODO(), config.RgpcTimeOut)
				defer cancle()
				_,err:=gcleint.Client.FriendNotify(ctx, notife)
				if err!=nil{
					logrus.Error(err)
				}

		}
	}

	utils.ResponseSuccess(c,nil)
}

type AgreeParm struct {
	NotifyID uint32 `json:"notify_id" form:"notify_id"`
}
func Agree(c *gin.Context) {
	var parm AgreeParm
	if err := c.ShouldBind(&parm); err != nil {
		utils.ResponseError(c, 500, err)
		return
	}
	var _, uid = models.GetuidAndusername(c)
	notify, err := models.NotifyFirst(uid, parm.NotifyID, 1)
	if err != nil || notify.ID == 0 {
		utils.ResponseError(c, 20004, errors.New("Nonexistent notify_id"))
		return
	}
	if err := models.FriendAdd(notify.Sender, notify.Receive, notify.ID); err != nil {
		logrus.Info(err)
		utils.DBerror(c)
		return
	}
	//todo 添加好友成功，发送一条推送信息
	user, err := config.GetUserFromRedis(notify.Sender)
	if user.Uid!=0 {
		gcleint, ok := service.ComitManage.GetComitServer(user.Srvname)
		if ok {

			ctx, cancle := context.WithTimeout(context.TODO(), config.RgpcTimeOut)
			defer cancle()
			_,err:=gcleint.Client.FriendAgree(ctx, &intercom.Agree{
				Notife: &intercom.FriendNotife{
					Greet:    notify.Greet,
					Nid:      notify.ID,
					Uid:      notify.Sender,
					Receiver: notify.Receive,
				},
			})
			if err!=nil{
				logrus.Error(err)
			}
		} else {
			gcleint := service.ComitManage.RandComitServer()
			ctx, cancle := context.WithTimeout(context.TODO(), config.RgpcTimeOut)
			defer cancle()
			_,err:=gcleint.Client.FriendAgree(ctx, &intercom.Agree{
				Notife: &intercom.FriendNotife{
					Greet:    notify.Greet,
					Nid:      notify.ID,
					Uid:      notify.Sender,
					Receiver: notify.Receive,
				},
			})
			if err!=nil{
				logrus.Error(err)
			}

		}

	}
	utils.ResponseSuccess(c, notify.ID)
}
//拒绝好友请求
func Refuse(c *gin.Context)  {
	var parm AgreeParm
	if err:=c.ShouldBind(&parm);err!=nil{
		utils.ResponseError(c,500,err)
	}
	var _,uid= models.GetuidAndusername(c)
	notify,err:=models.NotifyFirst(uid,parm.NotifyID,1)
	if err!=nil||notify.ID==0{
		utils.ResponseError(c,20004,errors.New("Nonexistent notify_id"))
		return
	}
	if err:=models.NotifyUpdateStatus(notify.ID,3);err!=nil{
		logrus.Info(err)
		utils.DBerror(c)
		return
	}
	utils.ResponseSuccess(c,notify.ID)

}
type DeleteFirendparm struct {
	FriendID uint32 `json:"friendid" binding:"required" form:"friendid"`
}
//删除好友
func DeleteFirend(c *gin.Context){

	var parm DeleteFirendparm
	if err:=c.ShouldBind(&parm);err!=nil{
		utils.ResponseError(c,500,err)
		return
	}
	var _,uid= models.GetuidAndusername(c)
	if models.FriendDelete(uid,parm.FriendID)!=nil{
		utils.DBerror(c)
		return
	}

	utils.ResponseSuccess(c,nil)
}

func FirendList(c *gin.Context)  {

	var _,uid= models.GetuidAndusername(c)
	var Relust=models.FirendList(uid)

	utils.ResponseSuccess(c,&Relust)

}

type  FirendSerachParm struct {
	Page uint32 `json:"page" form:"page"`
	Key string `json:"key" form:"key"`
}
func FirendSerach(c *gin.Context)  {

	var parm FirendSerachParm

	if err:=c.ShouldBind(&parm);err!=nil{
		utils.ResponseError(c,500,err)
		return
	}

	var Relust=models.UserSearch(parm.Key,parm.Page,20)

	utils.ResponseSuccess(c,&Relust)

}
type NotifyListParm struct {
	Page uint32 `json:"page" form:"page"`

}
func NotifyList(c *gin.Context)  {
	var parm NotifyListParm
	if err:=c.ShouldBind(&parm);err!=nil{
		utils.ResponseError(c,500,err)
		return
	}
	var _,uid= models.GetuidAndusername(c)
	var results=models.NotifyList(uid,parm.Page)
	utils.ResponseSuccess(c,&results)
}
func NotifyClear(c *gin.Context)  {
	var _,uid= models.GetuidAndusername(c)
	if models.NotifyClear(uid)!=nil{
		utils.DBerror(c)
		return
	}
	utils.ResponseSuccess(c,nil)

}