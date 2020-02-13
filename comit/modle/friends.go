package modle

import "time"

type Friend struct {
	ID  uint32 `gorm:"primary_key"`
	CreatedAt time.Time
	UpdatedAt time.Time
	Userid uint32
	Friendid uint32
}

func GetFriends(uid uint32)([]interface{},error)  {

	var friends []Friend
	var err=imdb.Model(&Friend{}).Select([]string{"friendid"}).Where("userid=?",uid).Scan(&friends).Error
	var friendIds =make([]interface{},len(friends))
	for  i:=0;i<len(friends);i++{
		friendIds[i]=friends[i].Friendid
	}
	return friendIds,err


}