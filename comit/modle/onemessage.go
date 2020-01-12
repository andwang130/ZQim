package modle

//离线消息
type Onemessage struct {
	Rek uint64  `gorm:"primary_key"`
	Time uint32
	Sender uint32
	Receiver uint32
	Msgtype  uint32
	Body    string  `gorm:"varchar(2000)"`
}

func AddOnemessage(one *Onemessage) error {

	return db.Create(one).Error
}
func DeleteOnemessage(rek uint64,receiver uint32) error {

	return db.Where("rek=?",rek).Where("receiver=?",receiver).Delete(&Onemessage{}).Error
}
