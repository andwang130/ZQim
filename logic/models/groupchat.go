package models

import (
	"errors"
	"logic/config"
	"logic/database"
)

type Groupchat struct {
	BaseModel
	//群公告
	GroupName string `gorm:"varchar(20)" json:"group_name"`
	Notice    string `gorm:"varchar(500)" json:"notice"`
	//群主id
	Owner  uint32 `gorm:"not null" json:"owner"`
	Avatar string `gorm:"not null;default:''" json:"avatar" `
	Status int    `gorm:"not null;default:1" json:"status"`
	//Users  []User `gorm:"many2many:groupchat_users;ForeignKey:groupid"`
}
type GroupchatUser struct {
	BaseModel
	Groupid uint32 `gorm:"not null"`
	Userid  uint32 `gorm:"not null"`
}

func GroupCreate(group *Groupchat,members []uint32) error {

	tx := database.GormPool.Begin()
	if err := tx.Create(group).Error; err != nil {
		tx.Callback()
		return err
	}
	members=append(members,group.Owner)
	for _,v:=range members{
		var groupUser = GroupchatUser{
			Groupid: group.ID,
			Userid:  v,
		}
		if err := tx.Create(&groupUser).Error; err != nil {
			tx.Callback()
			return err
		}
	}
	if err := tx.Commit().Error; err != nil {
		tx.Callback()
		return err
	}
	return nil
}

//退出群
func QuitGroup(gid, uid uint32) error {
	tx:=database.GormPool.Begin()
	if err:=config.GrouperDelete(gid);err!=nil{
		return err
	}
	if err:=tx.Where("groupid = ? amd userid=?", gid, uid).Delete(&GroupchatUser{}).Error;err!=nil{
		tx.Callback()
		return err
	}
	if err:=tx.Commit().Error;err!=nil{
		tx.Callback()
		return err
	}

	return nil
}

//解散群.,只有群主才能解散群
func DeleteGroup(gid uint32, uid uint32) error {
	tx:=database.GormPool.Begin()
	if err:=config.GrouperDelete(gid);err!=nil{
		tx.Callback()
		return err
	}
	if err:=tx.Where("groupid=? and owner=?",gid,uid).Delete(&Groupchat{}).Error;err!=nil{
		tx.Callback()
		return err
	}

	if err:=tx.Commit().Error;err!=nil{
		tx.Callback()
		return err
	}
	return nil
}
func GetGroup(gid uint32,uid uint32)(Groupchat,error)  {
	var groupchat Groupchat
	if database.GormPool.Model(&GroupchatUser{}).Where("groupid=? and userid=?",gid,uid).RecordNotFound(){
		return groupchat,errors.New("不属于该群组")
	}
	database.GormPool.Model(&Groupchat{}).Where("id=?",gid).First(&groupchat)
	return groupchat,nil
}