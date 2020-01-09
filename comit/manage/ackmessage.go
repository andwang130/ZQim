package manage

type Message struct {
	body []byte //消息体
	timeout int64  //过期时间
}
type AckMessageManage struct {
	messages map[uint64][]Message

}
