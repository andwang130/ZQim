package database

import (
	"fmt"
	"github.com/jinzhu/gorm"
	"github.com/spf13/viper"
	"log"
	"logic/models"
)

type Mysql struct {
	UserName string
	Password string
	IpHost   string
	DbName   string
}

type MyLogger struct {
}

func (logger *MyLogger) Print(values ...interface{}) {
	var (
		level  = values[0]
		source = values[1]
	)
	if level == "sql" {
		sql := values[3].(string)
		log.Println(sql, level, source)
	} else {
		log.Println(values)
	}

}

var GormPool *gorm.DB

func InitMysql() {
	var err error
	//driver:=viper.GetString("mysql.driver")
	username := viper.GetString("database.username")
	password := viper.GetString("database.password")
	host := viper.GetString("database.host")
	port := viper.GetInt("database.port")
	dbname := viper.GetString("database.dbname")
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=utf8&parseTime=True&loc=Local", username, password, host, port, dbname)
	GormPool, err = gorm.Open("mysql", dsn)
	//链接池设置
	GormPool.LogMode(true)
	GormPool.DB().SetMaxIdleConns(10)
	GormPool.DB().SetMaxOpenConns(100)
	if err != nil {
		fmt.Printf("mysql connect error %v", err)
	}
	if GormPool.Error != nil {
		fmt.Printf("database error %v", GormPool.Error)
	}
	GormPool.AutoMigrate(&models.User{},&models.Friend{},&models.Groupchat{},&models.Notify{},&models.GroupchatUser{})
}

