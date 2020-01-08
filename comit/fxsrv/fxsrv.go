package fxsrv
type HanleFunc func(*Connect,*Request)error
type CallBackFunc func(*Connect) 
type Server interface {
	//启动服务器
	Run()error
	//获取服务器的名称
	Name()string
	//初始化
	Init()
	//获取连接该服务器连接数
	GetConnNum() uint32
	AddRouter(uint16,HanleFunc)
	AddMiddleware(HanleFunc,...uint16)
}

func NewServer(ip string,port uint32,name string,opts ...Option)Server  {
	options:=newOptions(opts...)

	return &service{
		ip:ip,
		port:port,
		name:name,
		opts:options,
		routes:make(map[uint16]Route),
	}

}
