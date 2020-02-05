package request

type LoginInput struct {
	Username string `json:"username" form:"username" binding:"required"`
	Passwd string `json:"passwd" form:"passwd" binding:"required"`
}


type RegisterParm struct {
	Username string `json:"username" form:"username"`
	Passwd   string `json:"passwd" form:"passwd"`
	Sex      string `json:"sex" form:"sex"`
	Nickname string `json:"nickname"  form:"nickname"`
}

