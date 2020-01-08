package fxsrv

import (
	"errors"
	"sync"
)

type WorFunc func()
type WorkPool struct {

	workFuncChan chan WorFunc
	workSize uint32
	exitchan chan bool
	onec sync.Once
}

func (this *WorkPool)Start(){

	//启动协程池
	for i:=0;i<int(this.workSize);i++{
		go this.start()
	}

}

func newWorkPoll(worcksize,chansize uint32)*WorkPool {
	return &WorkPool{
		workFuncChan:make(chan WorFunc,chansize),
		workSize:worcksize,
		exitchan:make(chan bool),
	}
}
func (this *WorkPool)AddWrok(worFunc WorFunc)error {

	select {
	case <-this.exitchan:
		return errors.New("works is closed")
	case this.workFuncChan<-worFunc:
		return nil
	}

}

func (this *WorkPool)start()  {

	for{
		select {
		case <-this.exitchan:
			return
		case work:=<-this.workFuncChan:
			work()
		}

	}
}
func (this *WorkPool)Stop()  {

	//只执行一次
	this.onec.Do(func() {
		close(this.exitchan)
		close(this.workFuncChan)
	})

}