package router

import (
	"github.com/gin-gonic/gin"
	"logic/controller"
	"logic/middleware"
)

var Route *gin.Engine
func InitRouter()  {
	Route=gin.Default()
	var authrization=Route.Group("/", middleware.AuthMiddle)

	Route.POST("/login", controller.Login)
	Route.POST("/register", controller.Register)
	Route.POST("/logout", controller.Login)
	Route.GET("/user/get",controller.GetUser)
	authrization.GET("/checklogin",controller.Checklogin)
	authrization.GET("/notify/list",controller.NotifyList)
	authrization.POST("/notify/clear",controller.NotifyClear)
	//好友关系
	authrization.POST("/friend/add", controller.AddFriend)
	authrization.POST("/friend/agree", controller.Agree)
	authrization.POST("/friend/refuse", controller.Refuse)
	authrization.POST("/friend/delete", controller.DeleteFirend)
	authrization.GET("/friend/list", controller.FirendList)
	Route.GET("/friend/serach",controller.FirendSerach)
	//群组
	authrization.POST("/group/create", controller.CreateGroup)
	authrization.POST("/group/quit", controller.QuitGroup)
	authrization.POST("/group/delete", controller.DeleteGroup)
	authrization.GET("/group/get",controller.GetGroup)
}
