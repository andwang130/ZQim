package handles

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"logic/models"
)

type RegisterParm struct {
	Username string `json:"username" form:"username"`
	Passwd string `json:"passwd" form:"passwd"`
	Sex string `json:"sex" form:"sex"`
	Nickname string `json:"nickname"  form:"nickname"`
}
func Register(c *gin.Context)  {
	var parm RegisterParm
	if err:=c.ShouldBind(&parm);err!=nil{
		fmt.Println(err)
		ParmError(c,err.Error())
		return
	}
	var user models.User
	user.Username=parm.Username
	user.Nickname=parm.Nickname
	user.Sex=parm.Sex
	user.Passwd=parm.Passwd
	if models.UserAdd(&user)!=nil{
		RegisterError(c)
		return
	}
	Success(c,nil)
}

