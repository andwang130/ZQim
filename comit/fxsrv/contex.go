package fxsrv

type Contex struct {
	values map[interface{}]interface{}
}

func (this *Contex)Set(key interface{},value interface{}) {
	this.values[key]=value
}
func (this *Contex)Get(key interface{})(interface{},bool) {

	value,ok:=this.values[key]
	return value,ok
}
func (this *Contex)Delete(key interface{})  {
	delete(this.values,key)
}