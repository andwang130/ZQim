package fxsrv

import (
	"bytes"
	"encoding/binary"
)

type Request struct {
	Type uint16
	BodyLen uint32
	Flag uint8
	Body []byte
}

func (this *Request)GetBytes() []byte{
		b:=make([]byte,0)
		buf:=bytes.NewBuffer(b)
		binary.Write(buf,binary.BigEndian,this.Type)
		binary.Write(buf,binary.BigEndian,this.BodyLen)
		binary.Write(buf,binary.BigEndian,this.Flag)
		binary.Write(buf,binary.BigEndian,this.Body)
		return buf.Bytes()
}