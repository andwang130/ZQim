package models

import (
	"time"
)

type  User struct {
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

func UserLogin(username,passwd string)(*User,bool)  {

	var user =new(User)
	if db.Where("Username=?",username).Where("Passwd=?",passwd).First(user).RecordNotFound()==true{
		return user,false
	}else{
		return user,true
	}


}
func UserAdd(user *User)error  {
	user.Last=time.Now()
	return db.Create(user).Error
}
func UserToGrouplist(uid uint32)([]Groupchat,error)  {

	var groups []Groupchat
	err:=db.Model(&User{BaseModel:BaseModel{ID:uid}}).Related(&groups,"Groupchats").Error
	return groups,err
}

func UserSearch(key string,page,size uint32)[]User  {

	var users []User
	db.Model(&User{}).Where("username like ?","%"+key+"%").Offset((page-1)*size).Limit(size).Scan(&users)
	return users
}
func GetUser(uid uint32)User {
	var user User
	db.Model(&user).Where("id=?",uid).First(&user)

	return user
}