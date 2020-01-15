package utils

import (
	"encoding/json"
	"github.com/gin-gonic/gin"
	"net/http"
)

const (
	SuccessCode ResponseCode = 200
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

type ResponseCode int

type Response struct {
	ErrorCode ResponseCode `json:"errno"`
	ErrorMsg  string       `json:"errmsg"`
	Data      interface{}  `json:"data"`
}

func ResponseError(c *gin.Context, code ResponseCode, err error) {
	resp := &Response{ErrorCode: code, ErrorMsg: err.Error(), Data: ""}
	c.JSON(200, resp)
	response, _ := json.Marshal(resp)
	c.Set("response", string(response))
	//c.AbortWithError(200, err)
}

func ResponseSuccess(c *gin.Context, data interface{}) {
	resp := &Response{ErrorCode: SuccessCode, ErrorMsg: "", Data: data}
	c.JSON(200, resp)
	response, _ := json.Marshal(resp)
	c.Set("response", string(response))
}

//数据库错误
func DBerror(c *gin.Context)  {
	SetError(c,1,errCodes[1])
}

func SetError(c *gin.Context,code int,msg string)  {
	if msg==""{
		c.JSON(http.StatusOK,gin.H{"code":404,"data":nil,"msg":"Undefined error"})
	}else{
		c.JSON(http.StatusOK,gin.H{"code":code,"data":nil,"msg":msg})
	}
}