package fxsrv

type Route struct {
	handle HanleFunc
	middleware []HanleFunc
}