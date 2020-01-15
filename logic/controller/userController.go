package controller

import (
	"errors"
	"fmt"
	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
	"logic/config"
	"logic/models"
	"logic/request"
	"logic/service"
	"logic/utils"
	"strconv"
	"time"
)

type loginparm struct {
	Username string `json:"username" form:"useranme"`
	Passwd   string `json:"passwd" form:"passwd"`
}

//登录函数
func Login(c *gin.Context) {
	loginInput := &request.LoginInput{}
	if err := loginInput.BindingValidParams(c); err != nil {
		utils.ResponseError(c,2001,err)
		return
	}
	user, ok := models.UserLogin(loginInput.Username, loginInput.Passwd)
	if !ok {
		utils.ResponseError(c, 500, errors.New("登录错误"))
		return
	}
	claims := make(jwt.MapClaims)
	//过期时间
	claims["exp"] = time.Now().Add(time.Second * time.Duration(config.TokenOut)).Unix()
	//签发时间
	claims["iat"] = time.Now().Unix()
	claims["uid"] = strconv.Itoa(int(user.ID))
	claims["username"] = user.Username
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	sign, err := token.SignedString(config.SecretKey)
	if err != nil {
		fmt.Println(err)
		utils.ResponseError(c,2001,err)
		return
	}
	var result = make(map[string]string)
	fmt.Println("123456789")
	result["ip"] = service.ComitManage.NextTcpServer()
	result["token"] = sign

	utils.ResponseSuccess(c, result)

}

type RegisterParm struct {
	Username string `json:"username" form:"username"`
	Passwd   string `json:"passwd" form:"passwd"`
	Sex      string `json:"sex" form:"sex"`
	Nickname string `json:"nickname"  form:"nickname"`
}

func Register(c *gin.Context) {
	var parm RegisterParm
	if err := c.ShouldBind(&parm); err != nil {
		fmt.Println(err)
		utils.ResponseError(c,2001, err)
		return
	}
	var user models.User
	user.Username = parm.Username
	user.Nickname = parm.Nickname
	user.Sex = parm.Sex
	user.Passwd = parm.Passwd
	if models.UserAdd(&user) != nil {
		utils.ResponseError(c,2001,errors.New("注册失败"))
		return
	}
	utils.ResponseSuccess(c,nil)

}
