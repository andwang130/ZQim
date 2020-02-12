package modle

import (
	"time"
)

type Groupchat struct {
	ID  uint32 `gorm:"primary_key"`
	CreatedAt time.Time
	UpdatedAt time.Time
	//群公告
	GroupName string `gorm:"varchar(20)"`
	Notice    string `gorm:"varchar(500)"`
	//群主id
	Owner  uint32 `gorm:"not null"`
	Avatar string `gorm:"not null"`
	Status int    `gorm:"not null"`
}
type GroupchatUser struct {
	ID  uint32 `gorm:"primary_key"`
	CreatedAt time.Time
	UpdatedAt time.Time
	Groupid uint32 `gorm:"not null"`
	Userid  uint32 `gorm:"not null"`
}

func GetGroupchatUser(gid uint32)[]uint32  {
	var groupUsers []*GroupchatUser
	imdb.Model(&GroupchatUser{}).Select([]string{"userid"}).Where("groupid=?",gid).Scan(&groupUsers)
	var uids =make([]uint32,len(groupUsers))
	for index,v:=range groupUsers{

		uids[index]=v.Userid
	}
	print(groupUsers)
	return uids

}
