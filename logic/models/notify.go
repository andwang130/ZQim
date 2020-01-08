package models

type Notify struct {
	BaseModel
	Sender uint32 `gorm:"not null"`
 	Receive uint32 `gorm:"not null"`
	Status uint32  `gorm:"enum(1,2,3);default:1"`
}

func NotifyCreate(sender,receive uint32)error  {
	var notify=&Notify{
		Sender:sender,
		Receive:receive,
		Status:1,
	}
	return db.Create(notify).Error
}
func NotifyQuery(sender,receive uint32) bool  {

	return !db.Model(&Notify{}).Where("sender=?",sender).Where("receive=?",receive).Where("status=?",1).First(&Notify{}).RecordNotFound()
}
func NotifyFirst(uid,nid,status uint32)(Notify,error)  {
	var notify Notify
	err:=db.Model(Notify{}).Where("receive=?",uid).Where("id=?",nid).Where("status=?",status).First(&notify).Error
	return notify,err
}
func NotifyUpdateStatus(nid uint32,status uint32)error  {

	return db.Model(&Notify{}).Where("id=?",nid).Update("status",status).Error
}