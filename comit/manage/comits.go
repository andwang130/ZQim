package manage

type ComitServer struct {

}
type ComitManages struct {
	comits map[string]*ComitServer
}

func (this *ComitManages)AddComitServer(key string,server *ComitServer)  {
	this.comits[key]=server
}
func (this *ComitManages)DeleteComitServer(key string)  {
	delete(this.comits,key)
}
func (this *ComitManages)Watch() {


}