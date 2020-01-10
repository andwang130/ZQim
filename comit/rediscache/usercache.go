package rediscache

import (
	"encoding/json"
	"github.com/go-redis/redis"
	"strconv"
)

//用户连接缓存
var rediscli *redis.Client

type User struct {
	Uid uint32  `json:"uid"`  //用户id
	Srvname string `json:"srvname"`  //所在服务器名称
}
func init()  {
	var ops redis.Options
	ops.Addr="127.0.0.1:6379"
	rediscli=redis.NewClient(&ops)
	if err:=rediscli.Ping().Err();err!=nil{
		panic(err)
	}
}
func SetUser(uid uint32,user User) error {

	value,err:=json.Marshal(user)
	if err!=nil{
		return err
	}
	return rediscli.Set(strconv.Itoa(int(uid)),value,0).Err()
}
func GetUser(uid uint32)(User,error)  {

	var user User
	value,err:=rediscli.Get(strconv.Itoa(int(uid))).Bytes()
	if err!=nil{
		return user,err
	}
	if err:=json.Unmarshal(value,&user);err!=nil{
		return user,err
	}
	return user,nil
}