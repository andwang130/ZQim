package handles

import (
	"comit/fxsrv"
	"time"
)

func PingHandle(con *fxsrv.Connect,request fxsrv.Request)error  {

	con.SetheartTime(time.Now().Unix())
	return nil
}
