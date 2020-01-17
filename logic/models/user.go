package models

import (
	"encoding/json"
	"fmt"
	jwtgo "github.com/dgrijalva/jwt-go" //需要安装 然后调用这个jwt-go包
	"github.com/gin-gonic/gin"
	"logic/config"
	"logic/database"
	"logic/pkg/jwt"
	"strconv"
	"time"
)

type User struct {
	BaseModel
	Nickname   string      `gorm:"type:varchar(10);not null"`          //昵称
	Username   string      `gorm:"type:varchar(36);not null;unique"`   //登录用户名
	Passwd     string      `gorm:"type:varchar(36);json:"-",not null"` //登录密码
	Sex        string      `gorm:"type:enum('man','woman');not null"`
	Last       time.Time   //上次登录时间
	Lastip     string      `gorm:"type:varchar(16)"`
	Friends    []User      `gorm:"many2many:friends;ForeignKey:userid;AssociationForeignKey:userid"`
	Groupchats []Groupchat `gorm:"many2many:groupchat_users;ForeignKey:userid;AssociationForeignKey:id"`
}

type LoginResult struct {
	User  interface{} `json:"user"`
	Token string      `json:"token"`
}

//用户登陆
func UserLogin(username, passwd string) (token LoginResult, err error) {
	var user User
	obj := database.GormPool.Where("username = ? and passwd=?", username, passwd).First(&user)
	if err = obj.Error; err != nil {
		return
	}
	generateToken := GenerateToken(user)
	if err := SetUserRedis(user.ID, generateToken); err != nil {
		fmt.Println(err)
	}
	return generateToken, nil
}

//用户添加
func UserAdd(user *User) error {
	user.Last = time.Now()
	return database.GormPool.Create(user).Error
}

//用户群
func UserToGrouplist(uid uint32) ([]Groupchat, error) {
	var groups []Groupchat
	err := database.GormPool.Model(&User{BaseModel: BaseModel{ID: uid}}).Related(&groups, "Groupchats").Error
	return groups, err
}

//获取用户名和UId
func GetuidAndusername(c *gin.Context) (string, uint32) {
	var username = c.GetString("username")
	var uidstr = c.GetString("uid")
	uid, _ := strconv.Atoi(uidstr)
	fmt.Println(uid)
	return username, uint32(uid)
}

// 生成令牌  创建jwt风格的token
func GenerateToken(user User) LoginResult {
	j := &jwt.JWT{
		[]byte("newtrekWang"),
	}
	claims := jwt.CustomClaims{
		int(user.ID),
		user.Username,
		user.Passwd,
		jwtgo.StandardClaims{
			NotBefore: int64(time.Now().Unix() - 1000), // 签名生效时间
			ExpiresAt: int64(time.Now().Unix() + 3600), // 过期时间 一小时
			Issuer:    "newtrekWang",                   //签名的发行者
		},
	}

	token, err := j.CreateToken(claims)
	if err != nil {
		return LoginResult{
			User:  user,
			Token: token,
		}
	}
	data := LoginResult{
		User:  user,
		Token: token,
	}
	return data
}

//设置用户redis
func SetUserRedis(uid uint32,user LoginResult) error {
	value, err := json.Marshal(user)
	if err != nil {
		return err
	}
	return config.Rediscli.Set("user:"+strconv.Itoa(int(uid)), value, 0).Err()
}
