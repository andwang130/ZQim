package request

type LoginInput struct {
	Username string `json:"username" form:"username" binding:"required"`
	Passwd string `json:"passwd" form:"passwd" binding:"required"`
}


type RegisterParm struct {
	Username string `json:"username" form:"username" binding:"required"`
	Passwd   string `json:"passwd" form:"passwd" binding:"required"`
	Sex      string `json:"sex" form:"sex"`
	Nickname string `json:"nickname"  form:"nickname" binding:"required"`
	HeadImage string `json:"head_image" form:"head_image" binding:"required"`
}

type UpdateHeadImageParm struct {
	HeadImage string `json:"head_image" form:"head_image" binding:"required"`
}
