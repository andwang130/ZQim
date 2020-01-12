package rediscache

import "strconv"

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
