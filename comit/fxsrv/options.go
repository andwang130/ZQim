package fxsrv

import "runtime"

const readBufMaxDefault  =1024*4
const  writeBufMaxDefault=1024*4
type Options struct {
	readBufMax uint32
	writeBufMax uint32
	//连接建立的回调函数
	connectCallback func(*Connect)
	//连接关闭的回调函数
	closeCallback func(*Connect)

	timeout int64
	worksize uint32
	workchansize uint32
}

func newOptions(opts ...Option )*Options  {

	var options=&Options{
		readBufMax:readBufMaxDefault,
		writeBufMax:writeBufMaxDefault,
		timeout:100,
		worksize:uint32(runtime.NumCPU()),
		workchansize:uint32(runtime.NumCPU()),
	}
	for _,o:=range opts{
		o(options)
	}
	return options
}
type Option func(*Options)

func SetwriteBufMax(w uint32)Option  {
	return func(o *Options) {
		o.writeBufMax=w
	}
}
func SetreadBufMax(r uint32)Option  {

	return func(o *Options) {
		o.readBufMax=r
	}
}
func SetConnectCallback(callback CallBackFunc)Option  {

	return func(o *Options) {
		o.connectCallback=callback
	}
}
func SetCloseCallback(callback CallBackFunc)Option  {
	return func(o *Options) {
		o.closeCallback=callback
	}
}
func Settimeout(timeout int64)Option  {
	return func(o *Options) {
		o.timeout=timeout
	}
}
func SetWorkSize(size uint32)Option  {

	return func(o *Options) {
		o.worksize=size
	}
}
func SetWorkChanSize(size uint32)Option  {

	return func(o *Options) {
		o.workchansize=size
	}
}