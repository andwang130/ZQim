package models

import (
	"logic/config"
	"logic/database"
)

type Groupchat struct {
	BaseModel
	//群公告
	GroupName string `gorm:"varchar(20)"`
	Notice    string `gorm:"varchar(500)"`
	//群主id
	Owner  uint32 `gorm:"not null"`
	Avatar string `gorm:"not null;default:''" `
	Status int    `gorm:"not null;default:1"`
	//Users  []User `gorm:"many2many:groupchat_users;ForeignKey:groupid"`
}
type GroupchatUser struct {
	BaseModel
	Groupid uint32 `gorm:"not null"`
	Userid  uint32 `gorm:"not null"`
}

func GroupCreate(group Groupchat,members []uint32) error {

	tx := database.GormPool.Begin()
	if err := tx.Create(&group).Error; err != nil {
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
