package fxsrv

type Contex struct {
	values map[string]interface{}
}

func (this *Contex)Set(key string,value interface{}) {
	this.values[key]=value
}
func (this *Contex)Get(key string)(interface{},bool) {

	value,ok:=this.values[key]
	return value,ok
}