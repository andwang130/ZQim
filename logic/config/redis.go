package config

import (
	"encoding/json"
	"fmt"
	"github.com/go-redis/redis"
	"github.com/spf13/viper"
	"strconv"
)

//用户连接缓存
var Rediscli *redis.Client

type User struct {
	Uid     uint32 `json:"uid"`     //用户id
	Srvname string `json:"srvname"` //所在服务器名称
}

func InitRedis() {
	var ops redis.Options
	host := viper.GetString("redis.host")
	port := viper.GetInt("redis.port")
	ops.Addr = fmt.Sprintf("%s:%d", host, port)
	Rediscli = redis.NewClient(&ops)
	if err := Rediscli.Ping().Err(); err != nil {
		panic(err)
	}
}

func GetUserFromRedis(uid uint32) (User, error) {
	var user User
	value, err := Rediscli.Get("user:" + strconv.Itoa(int(uid))).Bytes()
	if err != nil {
		return user, err
	}
	if err := json.Unmarshal(value, &user); err != nil {
		return user, err
	}
	return user, nil
}
