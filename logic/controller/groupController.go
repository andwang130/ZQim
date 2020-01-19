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
	if err := models.GroupCreate(groupChat); err != nil {
		//log.WithFields(log.Fields{}).Info(err)
		logrus.Info(err)
		utils.ResponseError(c, 2001, err)
		return
	}
	utils.ResponseSuccess(c, "注册成功")
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
	var groupChat models.Groupchat
	if err:=models.DeleteGroup(groupChat,uid); err!=nil{
		utils.ResponseError(c, 500, err)
		return
	}
	utils.ResponseSuccess(c, "解散群成功")
}
