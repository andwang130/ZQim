package controller

import (
	"errors"
	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
	"logic/config"
	"logic/models"
	"logic/pkg/jwt"
	"logic/request"
	"logic/service"
	"logic/utils"
)

//登录函数
func Login(c *gin.Context) {
	parm := &request.LoginInput{}
	if err := c.ShouldBind(&parm); err != nil {
		utils.ResponseError(c, 2001, err)
		return
	}
	user, err := models.UserLogin(parm.Username, parm.Passwd)
	if err != nil {
		if err.Error() == "record not found" {
			utils.ResponseError(c, 500, errors.New("该用户不存在"))
			return
		} else {
			utils.ResponseError(c, 500, errors.New("登录错误"))
			return
		}
	}
	var result=make(map[string]interface{})
	result["ip"]=service.ComitManage.NextTcpServer()
	result["token"]=user.Token
	result["user"]=user.User
	utils.ResponseSuccess(c,&result)
	return

}

func Register(c *gin.Context) {
	parm := &request.RegisterParm{}
	if err := c.ShouldBind(&parm); err != nil {
		utils.ResponseError(c, 2001, err)
		return
	}
	var user models.User
	user.Username = parm.Username
	user.Nickname = parm.Nickname
	user.Sex = parm.Sex
	user.Passwd = parm.Passwd
	if err := models.UserAdd(&user); err != nil {
		//log.WithFields(log.Fields{}).Info(err)
		logrus.Info(err)
		utils.ResponseError(c, 2001, err)
		return
	}
	utils.ResponseSuccess(c, "注册成功")
}
type GetUserParm struct {
	Uid uint32 `json:"uid" form:"uid" binding:"required"`

}
func GetUser(c *gin.Context)  {
	//_,id:=getuidAndusername(c)
	var parm GetUserParm
	if err:=c.ShouldBind(&parm);err!=nil{
		utils.ResponseError(c, 2001, err)
		return
	}

	user:=models.GetUser(parm.Uid)
	utils.ResponseSuccess(c, &user)

}
func Checklogin(c *gin.Context)  {
	var newjwt =&jwt.JWT{
		SigningKey:config.SecretKey,
	}

	var _,uid=models.GetuidAndusername(c)
	var tokenString=c.Request.Header.Get("token")
	var newtoken,err=newjwt.RefreshToken(tokenString)
	if err!=nil{
		print(err.Error())
		utils.ResponseError(c,500,err)
		return
	}
	var user=models.GetUser(uid)
	var result=make(map[string]interface{})
	result["ip"]=service.ComitManage.NextTcpServer()
	result["token"]=newtoken
	result["user"]=user
	utils.ResponseSuccess(c,&result)
}
