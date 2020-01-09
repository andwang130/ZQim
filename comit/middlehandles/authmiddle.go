package middlehandles

import (
	"comit/fxsrv"
	"errors"
)

func AuthMiddleHandle(con *fxsrv.Connect,request *fxsrv.Request)error  {

	if !con.IsAuth(){
		return errors.New("not auth")
	}
	return nil
}
