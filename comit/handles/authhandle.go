package handles

import (
	"comit/config"
	"comit/manage"
	"comit/fxsrv"
	"comit/proto"
	"errors"
	"fmt"
	"github.com/dgrijalva/jwt-go"
	"github.com/golang/protobuf/proto"
	"strconv"
)
var SecretKey=[]byte("#2a56231!232&@3dsd1541")
func paresjwt(tokenstring string)(jwt.MapClaims,error)  {
	var claims jwt.MapClaims
	var token,err=jwt.Parse(tokenstring, func(token *jwt.Token) (i interface{}, e error) {
		return SecretKey,nil
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
func AuthHandle(con *fxsrv.Connect,request *fxsrv.Request)error  {

	fmt.Println("auth")
	var authmessage message.AuthMessage

	if err:=proto.Unmarshal(request.Body,&authmessage);err!=nil{

		fmt.Println(request.Body)
		fmt.Println(err)
		Authreply(con,config.MessagError)
		return errors.New("Unmarshal fail")
	}

	if authmessage.Token==""{
		Authreply(con,config.TokenOvertime)
		return errors.New("auth fail")
	}

	 claims,err:=paresjwt(authmessage.Token)
	 if err!=nil||claims.Valid()!=nil{
		 Authreply(con,config.TokenOvertime)
	 	return errors.New("token error")
	 }

	 uidstr,ok:=claims["uid"].(string)
	 if !ok{
		 fmt.Println("claims")
		 Authreply(con,config.AuthOthe)
		 return errors.New("token error")
	 }

    uid,err:=strconv.Atoi(uidstr)
    if err!=nil{
    	fmt.Println("Atoi")
		Authreply(con,config.AuthOthe)
    	return  errors.New("token error")
	}
	manage.ConManage.AddConnect(uint32(uid),con)
    fmt.Println(uid,"，登录了")
    con.SetId(uint32(uid))
	con.SetAuth(true)
	Authreply(con,config.AuthSuccess)
	return nil
}
func Authreply(con *fxsrv.Connect,code uint32)  {
	var authsuccess message.AuthSuccessMessage
	authsuccess.Status=code
	buf,err:=proto.Marshal(&authsuccess)
	if err!=nil{
		//todo
	}
	var req fxsrv.Request
	req.Type=config.Auth
	req.Body=buf
	req.BodyLen=uint32(len(buf))
	con.Write(&req)
}
