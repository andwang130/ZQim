package models

import (
	_ "github.com/go-sql-driver/mysql"
	"github.com/jinzhu/gorm"
	"time"
)
var db *gorm.DB
type BaseModel struct {
	ID  uint32 `gorm:"primary_key"`
	CreatedAt time.Time
	UpdatedAt time.Time

}


func init()  {

	var err error
	db,err=gorm.Open("mysql","root:ANDWANG130.@(127.0.0.1)/im?charset=utf8&parseTime=True&loc=Local")
	db.LogMode(true)
	if err!=nil{
		//数据库链接错误
		panic(err)
	}
	//链接池设置

	db.DB().SetMaxIdleConns(10)
	db.DB().SetMaxOpenConns(100)
	db.AutoMigrate(&User{},&Friend{},&Groupchat{},&Notify{},&GroupchatUser{})


}

