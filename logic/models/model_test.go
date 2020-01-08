package models

import "testing"

func TestGroupCreate(t *testing.T) {

	var group Groupchat
	group.Owner=1
	group.GroupName="群聊测试"
	group.Notice="测试"
	if GroupCreate(group)!=nil{
		t.Fail()
	}else{
		t.Log("创建群聊成功")
	}
}
func TestUserToGrouplist(t *testing.T) {

	if groups,err:=UserToGrouplist(1);err!=nil{
		t.Fail()
	}else {
		t.Log(groups)
	}
}
