package rediscache

import (
	"comit/modle"
	"strconv"
)

func GetGroupUsers(key uint32)([]uint32,error)  {
	var userlist []uint32
	cmd:=rediscli.SMembers("groupid:"+strconv.Itoa(int(key)))
	if err:=cmd.Err();err!=nil{

		return userlist,err
	}
	for _,v:=range cmd.Val(){
		uid,err:=strconv.Atoi(v)
		if err!=nil{
			return userlist,err
		}
		userlist=append(userlist,uint32(uid))
	}
	return userlist,nil
}

func GroupAddMembers(gid uint32,members []uint32) error {
	var intefaces=make([]interface{},len(members))
	for index,v:=range members{
		intefaces[index]=v
	}
	cmd:=rediscli.SAdd("groupid:"+strconv.Itoa(int(gid)),intefaces...)
	if cmd.Err()!=nil{
		return cmd.Err()
	}
	return nil
}
func GroupMebersCheck(gid uint32,uid uint32)bool  {

	var key="groupid:"+strconv.Itoa(int(gid))
	if rediscli.Exists(key).Val()<1{

		if groupmebers,err:=modle.GetGroupchatUser(gid);err!=nil{
			return false
		}else{
			GroupAddMembers(gid,groupmebers)
			for _,v:=range groupmebers{
				if v==uid{
					return true;
				}
			}
			return false

		}
	}
	return rediscli.SIsMember(key,uid).Val()
}