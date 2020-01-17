package request

type LoginInput struct {
	Username string `form:"username" validate:"required"`
	Passwd string `form:"password" validate:"required"`
}


type RegisterParm struct {
	Username string `json:"username" form:"username"`
	Passwd   string `json:"passwd" form:"passwd"`
	Sex      string `json:"sex" form:"sex"`
	Nickname string `json:"nickname"  form:"nickname"`
}

