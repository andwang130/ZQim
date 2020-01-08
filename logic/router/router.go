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

	authrization.POST("/friend/add",handles.AddFriend)
	authrization.POST("/friend/agree",handles.Agree)
	authrization.POST("/friend/refuse",handles.Refuse)
	authrization.POST("/friend/delete", handles.DeleteFirend)
	authrization.POST("/friend/list", handles.FirendList)

}
