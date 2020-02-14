package modle

import (
	"github.com/jinzhu/gorm"
	"github.com/spf13/viper"
	"fmt"
)

var db *gorm.DB
var imdb *gorm.DB

func imdbInit()  {
	var err error
	username := viper.GetString("imdb.username")
	password := viper.GetString("imdb.password")
	host := viper.GetString("imdb.ip")
	port := viper.GetInt("imdb.port")
	dbname := viper.GetString("imdb.dbname")
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=utf8&parseTime=True&loc=Local", username, password, host, port, dbname)
	imdb,err=gorm.Open("mysql",dsn)
	if err!=nil{
		panic(err)
	}
	//imdb.LogMode(true)
}
func init()  {


	var err error
	username := viper.GetString("messagedb.username")
	password := viper.GetString("messagedb.password")
	host := viper.GetString("messagedb.ip")
	port := viper.GetInt("messagedb.port")
	dbname := viper.GetString("messagedb.dbname")
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=utf8&parseTime=True&loc=Local", username, password, host, port, dbname)
	db,err=gorm.Open("mysql",dsn)
	if err!=nil{
		panic(err)
	}
	//db.LogMode(true)
	db.AutoMigrate(&Onemessage{},&GroupUserMessage{},&Message{},&Notifie{})
	imdbInit()


}
