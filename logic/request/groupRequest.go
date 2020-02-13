package request

type CreateGroupParam struct {
	GroupName  string `form:"group_name" json:"group_name" binding:"required"`
	Members  []uint32 `form:"members" json:"members" binding:"required"`
	Avatar  string `json:"avatar" form:"avatar" binding:"required"`
}

type QuitGroupParam struct {
	GroupId  uint32 `form:"id" json:"id" binding:"required"`
}

type DeleteGroupParam struct {
	GroupId  uint32 `form:"id" json:"id" binding:"required"`
}

type GetGroupParm struct {
	GroupId  uint32 `form:"id" binding:"required"`
}
type GetGetMembersParm struct {
	GroupId  uint32 `form:"id" binding:"required"`
	Page uint32 `json:"page" form:"page" binding:"required"`
}
type GetAllMembersParm struct {
	GroupId  uint32 `form:"id"  json:"id" binding:"required"`

}
type InvitationParm struct {
	GroupId  uint32 `form:"id" json:"id" binding:"required"`
	Members  []uint32 `form:"members" json:"members" binding:"required"`

}