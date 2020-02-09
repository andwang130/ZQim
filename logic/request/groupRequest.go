package request

type CreateGroupParam struct {
	GroupName  string `form:"group_name" json:"group_name" binding:"required"`
	Members  []uint32 `form:"members" json:"members" binding:"required"`
	Avatar  string `json:"avatar" form:"avatar"`
}

type QuitGroupParam struct {
	GroupId  uint32 `form:"id" binding:"required"`
}

type DeleteGroupParam struct {
	GroupId  uint32 `form:"id" binding:"required"`
}

type GetGroupParm struct {
	GroupId  uint32 `form:"id" binding:"required"`
}