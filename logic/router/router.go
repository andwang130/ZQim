package router

import (
	"github.com/gin-gonic/gin"
	"logic/handles"
	"logic/middle"
)

var Route *gin.Engine
func init()  {
	Route=gin.Default()
	var authrization=Route.Group("/",middle.AuthMiddle)

	Route.POST("/login", handles.Login)
	Route.POST("/register", handles.Register)
	Route.POST("/logout", handles.Login)
	Route.GET("/user/get",handles.GetUser)
	authrization.GET("/notify/list",handles.NotifyList)
	authrization.POST("/notify/clear",handles.NotifyClear)
	authrization.POST("/friend/add",handles.AddFriend)
	authrization.POST("/friend/agree",handles.Agree)
	authrization.POST("/friend/refuse",handles.Refuse)
	authrization.POST("/friend/delete", handles.DeleteFirend)
	authrization.GET("/friend/list", handles.FirendList)
	Route.GET("/friend/serach",handles.FirendSerach)


}
