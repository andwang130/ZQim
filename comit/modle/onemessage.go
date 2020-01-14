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
func DeleteOnemessageMany(reks []uint64,receiver uint32)error  {
	return db.Where("rek in (?)",reks).Where("receiver=?",receiver).Delete(&Onemessage{}).Error
}
func GetOneMessageList(receiver uint32,page,size uint32)[]*Onemessage  {
	var onemessages []*Onemessage
	db.Model(&Onemessage{}).Where("receiver=?",receiver).Limit(size).Offset((page-1)*size).Scan(&onemessages)
	return onemessages

}
