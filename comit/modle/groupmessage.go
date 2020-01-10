package modle

import (
	_ "github.com/go-sql-driver/mysql"
	"time"
)
type GroupMessage struct {
	Id        uint `gorm:"primary_key"`
	Rek uint64  `gorm:"primary_key"`
	CreatedAt time.Time
	UpdatedAt time.Time
	sender uint32
	receiver uint32
	msgid uint32
	Msg Message

}

type Message struct {
	Id        uint `gorm:"primary_key"`
	msgtype  uint32
	Body    string
}

func CreateGroupMessage()  {

}
func DeleteGroupMessage()  {

}