package models

import (
	"logic/database"
)

type Groupchat struct {
	BaseModel
	//群公告
	GroupName string `gorm:"varchar(20)"`
	Notice    string `gorm:"varchar(500)"`
	//群主id
	Owner  uint32 `gorm:"not null"`
	Status int    `gorm:"not null"`
	Users  []User `gorm:"many2many:groupchat_users;ForeignKey:groupid"`
}
type GroupchatUser struct {
	BaseModel
	Groupid uint32 `gorm:"not null"`
	Userid  uint32 `gorm:"not null"`
}

func GroupCreate(group Groupchat) error {

	tx := database.GormPool.Begin()
	if err := tx.Create(&group).Error; err != nil {
		tx.Callback()
		return err
	}
	var groupUser = GroupchatUser{
		Groupid: group.ID,
		Userid:  group.Owner,
	}
	if err := tx.Create(&groupUser).Error; err != nil {
		tx.Callback()
		return err
	}
	if err := tx.Commit().Error; err != nil {
		tx.Callback()
		return err
	}
	return nil
}
