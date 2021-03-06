package rediscache

import (
	"comit/modle"
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
	return rediscli.Set("userid:"+strconv.Itoa(int(uid)),value,0).Err()
}
func DeleteUser(uid uint32) error {
	var key="userid:"+strconv.Itoa(int(uid))
	return rediscli.Del(key).Err()
}
func GetUser(uid uint32)(User,error)  {

	var user User
	value,err:=rediscli.Get("userid:"+strconv.Itoa(int(uid))).Bytes()
	if err!=nil{
		return user,err
	}
	if err:=json.Unmarshal(value,&user);err!=nil{
		return user,err
	}
	return user,nil
}
func FriendCheck(uid uint32,friend uint32)bool  {
	var key="friends:"+strconv.Itoa(int(uid))
	if rediscli.Exists(key).Val()<1{

		if firendIds,err:=modle.GetFriends(uid);err!=nil{
			return false
		}else{
			rediscli.SAdd(key,firendIds...)
			for _,v:=range firendIds{
				if v==friend{
					return true;
				}
			}
			return false

		}
	}
	return rediscli.SIsMember(key,friend).Val()

}