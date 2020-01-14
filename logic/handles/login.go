package handles

import (
	"fmt"
	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
	"logic/config"
	"logic/manage"
	"logic/models"
	"strconv"
	"time"
)

type loginparm struct{
	Username string `json:"username" form:"useranme"`
	Passwd string `json:"passwd" form:"passwd"`
}
//登录函数
func Login(c *gin.Context)  {
	var login loginparm
	if err:=c.ShouldBind(&login);err!=nil{
		ParmError(c,err.Error())
		return
	}
	user,ok:=models.UserLogin(login.Username,login.Passwd)
	if !ok{
		LoginError(c)
		return
	}

	claims:=make(jwt.MapClaims)
	//过期时间
	claims["exp"] = time.Now().Add(time.Second*time.Duration(config.TokenOut)).Unix()
	//签发时间
	claims["iat"]=time.Now().Unix()
	claims["uid"]=strconv.Itoa(int(user.ID))
	claims["username"]=user.Username
	token:=jwt.NewWithClaims(jwt.SigningMethodHS256,claims)
	sign,err:=token.SignedString(config.SecretKey)
	if err!=nil{
		fmt.Println(err)
		LoginError(c)
		return
	}
	var result=make(map[string]string)
	fmt.Println("123456789")
	result["ip"]=manage.ComitManage.NextTcpServer()
	result["token"]=sign

	Success(c,result)


}
