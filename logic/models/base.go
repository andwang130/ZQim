package models

import (
	"logic/database"
	"time"
)
type BaseModel struct {
	ID  uint32 `gorm:"primary_key"`
	CreatedAt time.Time
	UpdatedAt time.Time
}

func InitMigrate()  {
	database.GormPool.AutoMigrate(&User{},&Friend{},&Groupchat{},&Notify{},&GroupchatUser{})
}