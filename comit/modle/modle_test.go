package modle

import (
	"fmt"
	"testing"
)

func TestGetGroupMessages(t *testing.T) {

	fmt.Println(len(GetGroupMessageList(2,1,10)))

}

func TestGetOneMessageList(t *testing.T) {

	fmt.Println(GetOneMessageList(2,1,10))
}