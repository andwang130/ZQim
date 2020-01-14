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
	Groupid uint32 `gorm:"not null"`
	Msgtype  uint32 `gorm:"not null"`
	Body    string  `gorm:"varchar(2000)"`
	Acknum uint32 `gorm:"not null"`
	Time uint32 `gorm:"not null"`
}

func CreateGroupMessage(message *Message)error  {

	return db.Create(message).Error
}

func CreateGroupUserMessage(usermessages []*GroupUserMessage )error  {

	var sql="INSERT INTO group_user_messages (rek,receiver) VALUES "

	for index,v:=range usermessages{
		if index<len(usermessages)-1 {
			sql += fmt.Sprintf("(%d,%d),",v.Rek,v.Receiver)
		}else{
			sql+=fmt.Sprintf("(%d,%d);",v.Rek,v.Receiver)
		}
		}

	return 	db.Exec(sql).Error
}
func DeleteGroupUserMessage(rek uint64,receiver uint32)error  {

	return db.Where("receiver=?",receiver).Where("rek=?",rek).Delete(&GroupUserMessage{}).Error
}
func DeleteGroupUserMessageMany(reks []uint64,receiver uint32)error  {
	return db.Where("rek in (?)",reks).Where("receiver=?",receiver).Delete(&GroupUserMessage{}).Error
}
type CompleteMessage struct {
	GroupUserMessage
	Message

}


func GetGroupMessageList(receiver uint32,page,size uint32)[]*CompleteMessage  {

	var completes []*CompleteMessage
	db.Model(&GroupUserMessage{}).Select("*").Where("receiver=?", receiver).Joins(
		"left join messages on messages.rek=group_user_messages.rek").Limit(size).Offset((page-1)*size).Scan(&completes)

	return completes


}