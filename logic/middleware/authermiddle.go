package middleware

import (
	"errors"
	"fmt"
	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
	"logic/config"
	jwt2 "logic/pkg/jwt"
	"logic/utils"
)

//解析jwt的token
func paresjwt(tokenstring string)(jwt.MapClaims,error)  {
	var claims jwt.MapClaims
	var token,err=jwt.Parse(tokenstring, func(token *jwt.Token) (i interface{}, e error) {
		return config.SecretKey,nil
	})
	if err!=nil{
		fmt.Println(err)
		return  claims,err
	}


	var ok bool
	if claims, ok = token.Claims.(jwt.MapClaims); ok && token.Valid {
		return claims,nil
	} else {
		return  claims,errors.New("clamis error")
	}

}
func AuthMiddle(c *gin.Context)  {
	var tokenString=c.Request.Header.Get("token")
	if tokenString==""{
		utils.ResponseError(c,500,errors.New("token error"))
		c.Abort()
		return
	}
	var j=&jwt2.JWT{SigningKey:config.SecretKey}
	var claims,err=j.ParseToken(tokenString)
	if err!=nil{
		utils.ResponseError(c,500,errors.New("token error"))
		c.Abort()
		return
	}
	 var checkerror=claims.Valid()
	if checkerror!=nil{
		utils.ResponseError(c,500,errors.New("token error"))
		c.Abort()
		return
	}

	c.Set("username",claims.Name)
 	c.Set("uid",claims.ID)
	c.Next()
}
