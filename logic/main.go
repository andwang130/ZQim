package main

import (
	"logic/router"
	//_ "logic/ectdcofig"
)
func main() {

	router.Route.Run(":8080")
}
