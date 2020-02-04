package models

import (
	"encoding/json"
	"fmt"
	jwtgo "github.com/dgrijalva/jwt-go" //需要安装 然后调用这个jwt-go包
	"github.com/gin-gonic/gin"
	log "github.com/sirupsen/logrus"
	"logic/config"
	"logic/database"
	"logic/pkg/jwt"
	"strconv"
	"time"
)

type User struct {
	BaseModel
	Nickname string `gorm:"type:varchar(10);not null" json:"nickname"` //昵称
	Username string `gorm:"type:varchar(36);not null;unique" json:"username"` //登录用户名
	Passwd string `gorm:"type:varchar(36);not null" json:"_"` //登录密码
	Sex string   `gorm:"type:enum('man','woman');not null" json:"sex"`
	HeadImage string `gorm:"varchar(200)" json:"head_image"`
	Expl string `gorm:"varcahr(200)" json:"expl"`
	Last time.Time `json:"last"`    //上次登录时间
	Lastip string `gorm:"type:varchar(16)" json:"lastip"`
	Friends []User `gorm:"many2many:friends;ForeignKey:userid;AssociationForeignKey:userid" json:"friends"`
	Groupchats []Groupchat `gorm:"many2many:groupchat_users;ForeignKey:userid;AssociationForeignKey:id" json:"groupchats"`
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
		log.Info(err)
		return
	}
	generateToken := GenerateToken(user)
	if err := SetUserRedis(user.ID, generateToken); err != nil {
		log.Info(err)
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

func UserSearch(key string,page,size uint32)[]User  {

	var users []User
	database.GormPool.Model(&User{}).Where("username like ?","%"+key+"%").Offset((page-1)*size).Limit(size).Scan(&users)
	return users
}