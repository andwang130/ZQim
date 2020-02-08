package models

import (
	"logic/database"
	"time"
	"fmt"
)
type BaseModel struct {
	ID  uint32 `gorm:"primary_key"`
	CreatedAt time.Time
	UpdatedAt time.Time
}

func InitMigrate() {
	migrate := database.GormPool.AutoMigrate(&User{}, &Friend{}, &Groupchat{}, &Notify{}, &GroupchatUser{}).Error
	fmt.Printf("这是建表错误:%s",migrate)
}
