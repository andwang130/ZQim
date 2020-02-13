package models

import (
	"errors"
	"logic/config"
	"logic/database"
	"fmt"
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
	Groupid uint32 `gorm:"not null" json:"groupid"`
	Userid  uint32 `gorm:"not null" json:"userid"`
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

	if err:=tx.Where("groupid = ? and userid=?", gid, uid).Delete(&GroupchatUser{}).Error;err!=nil{
		tx.Callback()
		return err
	}
	var groupchat Groupchat
	var err error
	if groupchat,err=GetGroup(gid,uid);err!=nil{
		return err
	}
	//群主退出群聊，换一个群主
	if groupchat.Owner==uid{
		var groupchatUser GroupchatUser
		if tx.Model(&GroupchatUser{}).Where("groupid=?",gid).First(&groupchatUser).Error!=nil{
			tx.Callback()
			return err
		}

		//找不到其他成员，只剩自己,删除群
		if groupchatUser.Userid==0{
			if err:= tx.Where("groupid=?",gid).Delete(&Groupchat{}).Error;err!=nil{
				tx.Callback()
				return err
			}
		}else {
			//更新新的群主
			if err:=tx.Model(&Groupchat{}).Update("owner",groupchatUser.Userid).Error;err!=nil{
				tx.Callback()
				return err
			}
		}
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

type Member struct {
	ID  uint32 `gorm:"primary_key"`
	Nickname string `gorm:"type:varchar(10);not null" json:"nickname"` //昵称
	Username string `gorm:"type:varchar(36);not null;unique" json:"username"` //登录用户名
	HeadImage string `gorm:"varchar(200)" json:"head_image"`

}
func GetGroupMembers(gid,uid uint32,page uint32)([]Member,error,uint32)  {

	var users []Member
	var count uint32
	if database.GormPool.Model(&GroupchatUser{}).Where("groupid=? and userid=?",gid,uid).RecordNotFound(){
		return users,errors.New("不属于该群组"),count
	}
	err:=database.GormPool.Model(&GroupchatUser{}).Select("users.*").Where("groupid=?",gid).Count(&count).
		Joins("left join users on users.id=groupchat_users.userid").Limit(20).Offset((page-1)*20).Scan(&users).Error


	return users,err,count
	
}
func GetGroupAllMembers(gid,uid uint32) ([]uint32,error) {
	var groupuser []GroupchatUser

	if database.GormPool.Model(&GroupchatUser{}).Where("groupid=? and userid=?",gid,uid).RecordNotFound(){
		return []uint32{},errors.New("不属于该群组")
	}
	err:=database.GormPool.Model(&GroupchatUser{}).Where("groupid=?",gid).Scan(&groupuser).Error
	var uids =make([]uint32,len(groupuser))
	for index,v:=range groupuser{
		uids[index]=v.Userid
	}
	return uids,err
}
func Invitation(gid,uid uint32,members []uint32)error  {

	if database.GormPool.Model(&GroupchatUser{}).Where("groupid=? and userid=?",gid,uid).RecordNotFound(){
		return errors.New("不属于该群组")
	}
	if config.GrouperDelete(gid)!=nil{
		return errors.New("缓存错误")
	}
	var sql="INSERT INTO groupchat_users (groupid,userid) VALUES"
	for index,v:=range members{
		if index<len(members)-1 {
			sql += fmt.Sprintf("(%d,%d),",gid,v)
		}else{
			sql+=fmt.Sprintf("(%d,%d);",gid,v)
		}
	}
	return database.GormPool.Exec(sql).Error
}
func Removemembers(gid,uid uint32,members []uint32)error  {
	if database.GormPool.Model(&Groupchat{}).Where("id=? and owner=?",gid,uid).RecordNotFound(){
		return errors.New("不是群主")
	}
	if config.GrouperDelete(gid)!=nil{
		return errors.New("缓存错误")
	}
	return database.GormPool.Where("groupid = ? and userid in (?)",gid,members).Delete(&GroupchatUser{}).Error

}