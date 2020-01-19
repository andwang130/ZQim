package request

type CreateGroupParam struct {
	GroupName  string `form:"group_name" validate:"required"`
	Avatar  string `form:"group_name" validate:"required"`
}

type QuitGroupParam struct {
	GroupId  uint32 `form:"id" validate:"required"`
}

type DeleteGroupParam struct {
	GroupId  uint32 `form:"id" validate:"required"`
}