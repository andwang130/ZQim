package controller

import (
	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
	"logic/models"
	"logic/request"
	"logic/utils"
)

//创建群
func CreateGroup(c *gin.Context) {
	var _, uid = models.GetuidAndusername(c)
	var parm request.CreateGroupParam
	if err := c.ShouldBind(&parm); err != nil {
		utils.ResponseError(c, 500, err)
		return
	}
	var groupChat models.Groupchat
	groupChat.GroupName = parm.GroupName
	groupChat.Avatar = parm.Avatar
	groupChat.Owner = uid
	if err := models.GroupCreate(&groupChat,parm.Members); err != nil {
		//log.WithFields(log.Fields{}).Info(err)
		logrus.Info(err)
		utils.ResponseError(c, 2001, err)
		return
	}
	utils.ResponseSuccess(c, &groupChat)
}

//退出群
func QuitGroup(c *gin.Context) {
	var parm request.QuitGroupParam
	var _, uid = models.GetuidAndusername(c)
	if err := c.ShouldBind(&parm); err != nil {
		utils.ResponseError(c, 500, err)
		return
	}
	if err:=models.QuitGroup(parm.GroupId, uid);err!=nil{
		utils.DBerror(c)
		return
	}
	utils.ResponseSuccess(c, "退群成功")
}

//解散群
func DeleteGroup(c *gin.Context) {
	var parm request.DeleteGroupParam
	var _, uid = models.GetuidAndusername(c)
	if err := c.ShouldBind(&parm); err != nil {
		utils.ResponseError(c, 500, err)
		return
	}
	if err:=models.DeleteGroup(parm.GroupId,uid); err!=nil{
		utils.ResponseError(c, 500, err)
		return
	}
	utils.ResponseSuccess(c, "解散群成功")
}
//获取群数据
func GetGroup(c *gin.Context)  {
	var parm request.GetGroupParm
	var _, uid = models.GetuidAndusername(c)
	if err:=c.ShouldBind(&parm);err!=nil{
		utils.ResponseError(c, 500, err)
		return
	}
	if groupchat,err:=models.GetGroup(parm.GroupId,uid);err!=nil{
		utils.ResponseError(c, 500, err)
		return
	}else {
		utils.ResponseSuccess(c,&groupchat)

	}
}
