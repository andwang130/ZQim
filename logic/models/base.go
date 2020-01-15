package models

import (
	_ "github.com/go-sql-driver/mysql"
	"time"
)
type BaseModel struct {
	ID  uint32 `gorm:"primary_key"`
	CreatedAt time.Time
	UpdatedAt time.Time
}


