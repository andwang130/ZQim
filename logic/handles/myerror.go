package handles

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
)

var errCodes map[int]string

func init()  {
	errCodes=make(map[int]string)
	errCodes[1]="dberror"
	errCodes[2]="ParmError"
	errCodes[3]="username or passwd error"
	errCodes[4]="username  already exists"
	errCodes[5]="token error"
}

//成功
func Success(c *gin.Context,data interface{})  {
	c.JSON(http.StatusOK,gin.H{"code":0,"data":data,"msg":"Success"})
}

//数据库错误
func DBerror(c *gin.Context)  {

	SetError(c,1,errCodes[1])
}
//参数错误
func ParmError(c *gin.Context,msg string)  {
	SetError(c,2,msg)
}
func RegisterError(c *gin.Context)  {
	SetError(c,4,errCodes[4])
}
//登录用户名或者密码错误
func LoginError(c *gin.Context)  {
	SetError(c,3,errCodes[3])
}
func TokenError(c *gin.Context)  {
	SetError(c,5,errCodes[5])
}
func SetError(c *gin.Context,code int,msg string)  {
	if msg==""{
		c.JSON(http.StatusOK,gin.H{"code":404,"data":nil,"msg":"Undefined error"})
	}else{
		c.JSON(http.StatusOK,gin.H{"code":code,"data":nil,"msg":msg})
	}
}

func getuidAndusername(c *gin.Context) (string,uint32) {
	var username=c.GetString("username")
	var uidstr=c.GetString("uid")
	uid,_:=strconv.Atoi(uidstr)
	fmt.Println(uid)
	return username,uint32(uid)
}

