package config

import (
	"github.com/spf13/viper"
	"os"
	"time"
)

var SecretKey = []byte("#2a56231!232&@3dsd1541")

const ServerName = ""
const RgpcTimeOut = time.Second * 2

var TokenOut = 3600000

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
