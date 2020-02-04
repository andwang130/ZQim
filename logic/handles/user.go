package handles

import (
	"github.com/gin-gonic/gin"
	"logic/models"
)

type GetUserParm struct {
	Uid uint32 `json:"uid" form:"uid" binding:"required"`

}
func GetUser(c *gin.Context)  {
	//_,id:=getuidAndusername(c)
	var parm GetUserParm
	if err:=c.ShouldBind(&parm);err!=nil{
		ParmError(c,err.Error())
		return
	}

	user:=models.GetUser(parm.Uid)
	Success(c,user)


	
	
	
}

