package models

import (
	"time"
)

type  User struct {
	BaseModel
	Nickname string `gorm:"type:varchar(10);not null"` //昵称
	Username string `gorm:"type:varchar(36);not null;unique"` //登录用户名
	Passwd string `gorm:"type:varchar(36);not null"` //登录密码
	Sex string   `gorm:"type:enum('man','woman');not null"`
	Last time.Time    //上次登录时间
	Lastip string `gorm:"type:varchar(16)"`
	Friends []User `gorm:"many2many:friends;ForeignKey:userid;AssociationForeignKey:userid"`
	Groupchats []Groupchat `gorm:"many2many:groupchat_users;ForeignKey:userid;AssociationForeignKey:id"`
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