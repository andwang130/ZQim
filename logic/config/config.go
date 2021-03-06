package config

import (
	"github.com/fsnotify/fsnotify"
	"github.com/prometheus/common/log"
	"github.com/spf13/viper"
	"os"
	"time"
)

var SecretKey = []byte("#2a56231!232&@3dsd1541")
const FriendNotife=11
const ServerName = ""
const RgpcTimeOut = time.Second * 2
const TokenOut = 3600000
var(
	Endpoint string

	AccessKeyId string
	AccessKeySecret string
	BucketName string
)

func InitConfig() {
	path, err := os.Getwd()
	if err != nil {
		panic(err)
	}
	viper.AddConfigPath(path + "/config/dev")
	viper.SetConfigName("config")
	viper.SetConfigType("yaml")
	if err := viper.ReadInConfig(); err != nil {
		panic(err)
	}
	Endpoint=viper.GetString("oss.Endpoint")
	AccessKeyId=viper.GetString("oss.AccessKeyId")
	AccessKeySecret=viper.GetString("oss.AccessKeySecret")
	BucketName=viper.GetString("oss.BucketName")
	// 热更新配置文件
	watchConfig()
}

// 监控配置文件变化
func watchConfig() {
	viper.WatchConfig()
	viper.OnConfigChange(func(ev fsnotify.Event) {
		// 配置文件更新了
		log.Infof("Config file changed: %s", ev.Name)
	})
}
