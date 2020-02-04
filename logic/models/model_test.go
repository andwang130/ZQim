package models

import (
	"fmt"
	"math/rand"
	"strconv"
	"testing"
	"time"
)
var imges= []string{
	"https://pic.feizl.com/upload/allimg/200131/gxtxsyskopyp2al.jpg",
	"https://pic.feizl.com/upload/allimg/200129/gxtxwc2bxjy4u32.gif",
	"https://pic.feizl.com/upload/allimg/200126/gxtxdq4qa4dc0cl.jpg",
	"https://pic.feizl.com/upload/allimg/200121/gxtxznjttyxjszo.jpg",
	"https://pic.feizl.com/upload/allimg/200121/gxtxzsitm0z1kwg.jpg",
	"https://pic.feizl.com/upload/allimg/200115/gxtxbcxtumrhizy.jpg",
	}
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
func TestNotifyList(t *testing.T) {
	results:=NotifyList(3,1)
	for _,v:=range results{
		fmt.Println(v)
	}
}
func TestUserAdd(t *testing.T) {

	for i:=600;i<700;i++{
	rand.Seed(time.Now().Unix())
	 var n=rand.Intn(len(imges))
	 var user=User{Username:strconv.Itoa(i)+"@qq.com",
	 	Nickname:"王"+strconv.Itoa(i),
	 	Passwd:"123456789",
	 	Expl:"说明测试",
	 	Sex:"man",
	    HeadImage:imges[n],
	 }
	 UserAdd(&user)
	}

}
func TestFriendAdd(t *testing.T) {
	for i:=4;i<100;i++{
		NotifyCreate(uint32(i),3,"你好,我得id是："+strconv.Itoa(i))
	}
}