package models

import (
	"logic/config"
	"logic/database"
	"time"
)

type Friend struct {
	BaseModel
	Userid uint32
	Friendid uint32
}

func FriendAdd( uid,friendid,nid uint32)error  {

	if err:=config.FriendDelete(uid);err!=nil{
		return err
	}
	if err:=config.FriendDelete(friendid);err!=nil{
		return err
	}
	tx:= database.GormPool.Begin()
	var friend1 Friend
	friend1.Userid=uid
	friend1.Friendid=friendid
	var friend2 Friend
	friend2.Userid=friendid
	friend2.Friendid=uid
	if err:=tx.Create(&friend1).Error;err!=nil{
		tx.Callback()
		return err
	}
	if err:=tx.Create(&friend2).Error;err!=nil{
		tx.Callback()
		return err
	}
	if err:=tx.Model(&Notify{}).Where("id=?",nid).Update("status",2).Error;err!=nil{
		tx.Callback()
		return err
	}
	if err:=tx.Commit().Error;err!=nil{
		tx.Callback()
		return err
	}
	return nil
}
func FriendDelete(uid,friendid uint32 )error  {
	if err:=config.FriendDelete(uid);err!=nil{
		return err
	}
	return database.GormPool.Where("Userid=?",uid).Where("Friendid=?",friendid).Delete(&Friend{}).Error
}

type FirendListResult struct {
	Id uint32 `json:"id"`
	Nickname string `json:"nickname"`
	Username string `json:"username"`
	HeadImage string `gorm:"varchar(200)" json:"head_image"`
	Sex string `json:"sex"`
	Last time.Time `json:"last"`   //上次登录时间
}
func FirendList(uid uint32)[]FirendListResult  {
	var Result []FirendListResult
	database.GormPool.Model(&Friend{}).Select([]string{"users.id","nickname","sex","last","username","head_image"}).Where("Userid=?",uid).Joins("left join users on users.id=friends.friendid").Scan(&Result)
	//var user User
	//user.ID=uid
	//var users []User
	//database.GormPool.Model(&user).Related(&users,"friends")

	return Result
}

func FirendQuery(uid,firendid uint32,)bool  {
	return !database.GormPool.Model(&Friend{}).Where("userid=?",uid).Where("friendid=?",firendid).First(&Friend{}).RecordNotFound()

}