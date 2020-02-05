package modle

type Notifie struct {
	ID uint32 `gorm:"primary_key"`
	Uid uint32
	NotifieType uint32
	Body []byte
}

func CreateNotifie(notifie *Notifie)error  {

	return db.Create(&notifie).Error
}
func NotifieList(uid uint32)[]Notifie  {
	var notifies []Notifie
	db.Model(&Notifie{}).Where("uid=?",uid).Scan(&notifies);
	return notifies
}

func DeleteNotifieList(ids []uint32)error  {

	return db.Where("id in (?)",ids).Delete(&Notifie{}).Error
}