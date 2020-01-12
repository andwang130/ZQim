package modle

import (
	"fmt"
	_ "github.com/go-sql-driver/mysql"
)
type GroupUserMessage struct {
	Id        uint `gorm:"primary_key"`
	Rek uint64    `gorm:"not null"`
	Receiver uint32 `gorm:"not null"`
}

type Message struct {
	Rek        uint64 `gorm:"primary_key"`
	Sender uint32    `gorm:"not null"`
	Msgtype  uint32 `gorm:"not null"`
	Body    string  `gorm:"varchar(2000)"`
	Acknum uint32 `gorm:"not null"`
	Time uint32 `gorm:"not null"`
}

func CreateGroupMessage(message *Message)error  {

	return nil
	//return db.Create(message).Error
}

func CreateGroupUserMessage(usermessages []*GroupUserMessage )error  {

	var sql="NSERT INTO group_user_message ('rek','receiver') VALUES "

	for index,v:=range usermessages{
		if index<len(usermessages)-1 {
			sql += fmt.Sprintf("(%d,%d)",v.Rek,v.Receiver)
		}else{
			sql+=fmt.Sprintf("(%d,%d);",v.Rek,v.Receiver)
		}
		}
	return nil
	//return 	db.Exec(sql).Error
}
func DeleteGroupUserMessage(rek uint64,receiver uint32)error  {

	//return db.Where("receiver=?",receiver).Where("rek=?",rek).Delete(&GroupUserMessage{}).Error
	return nil
}