package modle

import "github.com/jinzhu/gorm"

var db *gorm.DB
func init()  {

	var err error
	db,err=gorm.Open("mysql","root:ANDWANG130.@(127.0.0.1)/message?charset=utf8&parseTime=True&loc=Local")
	if err!=nil{
		panic(err)
	}
	db.LogMode(true)
	db.AutoMigrate(&Onemessage{})

}
