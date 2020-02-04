package models

import (
	"fmt"
	"time"
)

type Friend struct {
	BaseModel
	Userid uint32
	Friendid uint32
}

func FriendAdd( uid,friendid,nid uint32)error  {

	tx:=db.Begin()

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

	return db.Where("Userid=?",uid).Where("Friendid=?",friendid).Delete(&Friend{}).Error
}

type FirendListResult struct {
	Id uint32
	Nickname string
	Username string
	Sex string
	Last time.Time    //上次登录时间
}
func FirendList(uid uint32)[]FirendListResult  {
	var Result []FirendListResult
	//db.Model(&Friend{}).Select([]string{"users.id","nickname","sex","last","username"}).Where("Userid=?",uid).Joins("left join users on users.id=friends.friendid").Scan(&Result)
	var user User
	user.ID=uid
	var users []User
	db.Model(&user).Related(&users,"friends")
	fmt.Println(users)
	return Result
}
func FirendQuery(uid,firendid uint32,)bool  {

	return !db.Model(&Friend{}).Where("userid=?",uid).Where("friendid=?",firendid).First(&Friend{}).RecordNotFound()

}
