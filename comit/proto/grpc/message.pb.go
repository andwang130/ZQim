// Code generated by protoc-gen-go. DO NOT EDIT.
// source: message.proto

package intercom

import (
	fmt "fmt"
	proto "github.com/golang/protobuf/proto"
	math "math"
)

// Reference imports to suppress errors if they are not otherwise used.
var _ = proto.Marshal
var _ = fmt.Errorf
var _ = math.Inf

// This is a compile-time assertion to ensure that this generated file
// is compatible with the proto package it is being compiled against.
// A compilation error at this line likely means your copy of the
// proto package needs to be updated.
const _ = proto.ProtoPackageIsVersion3 // please upgrade the proto package

type OneMessage struct {
	//消息编号
	Rek uint64 `protobuf:"varint,1,opt,name=rek,proto3" json:"rek,omitempty"`
	//发送方id
	Sender uint32 `protobuf:"varint,2,opt,name=sender,proto3" json:"sender,omitempty"`
	//接收方id
	Receiver uint32 `protobuf:"varint,3,opt,name=receiver,proto3" json:"receiver,omitempty"`
	//消息内容
	Msgbody string `protobuf:"bytes,4,opt,name=msgbody,proto3" json:"msgbody,omitempty"`
	//消息类型
	Msgtype uint32 `protobuf:"varint,5,opt,name=msgtype,proto3" json:"msgtype,omitempty"`
	//消息时序
	Time                 uint32   `protobuf:"varint,6,opt,name=time,proto3" json:"time,omitempty"`
	XXX_NoUnkeyedLiteral struct{} `json:"-"`
	XXX_unrecognized     []byte   `json:"-"`
	XXX_sizecache        int32    `json:"-"`
}

func (m *OneMessage) Reset()         { *m = OneMessage{} }
func (m *OneMessage) String() string { return proto.CompactTextString(m) }
func (*OneMessage) ProtoMessage()    {}
func (*OneMessage) Descriptor() ([]byte, []int) {
	return fileDescriptor_33c57e4bae7b9afd, []int{0}
}

func (m *OneMessage) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_OneMessage.Unmarshal(m, b)
}
func (m *OneMessage) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_OneMessage.Marshal(b, m, deterministic)
}
func (m *OneMessage) XXX_Merge(src proto.Message) {
	xxx_messageInfo_OneMessage.Merge(m, src)
}
func (m *OneMessage) XXX_Size() int {
	return xxx_messageInfo_OneMessage.Size(m)
}
func (m *OneMessage) XXX_DiscardUnknown() {
	xxx_messageInfo_OneMessage.DiscardUnknown(m)
}

var xxx_messageInfo_OneMessage proto.InternalMessageInfo

func (m *OneMessage) GetRek() uint64 {
	if m != nil {
		return m.Rek
	}
	return 0
}

func (m *OneMessage) GetSender() uint32 {
	if m != nil {
		return m.Sender
	}
	return 0
}

func (m *OneMessage) GetReceiver() uint32 {
	if m != nil {
		return m.Receiver
	}
	return 0
}

func (m *OneMessage) GetMsgbody() string {
	if m != nil {
		return m.Msgbody
	}
	return ""
}

func (m *OneMessage) GetMsgtype() uint32 {
	if m != nil {
		return m.Msgtype
	}
	return 0
}

func (m *OneMessage) GetTime() uint32 {
	if m != nil {
		return m.Time
	}
	return 0
}

type GroupMessage struct {
	Sender uint32 `protobuf:"varint,2,opt,name=sender,proto3" json:"sender,omitempty"`
	//群组Id
	Groupid              uint32   `protobuf:"varint,3,opt,name=groupid,proto3" json:"groupid,omitempty"`
	Msgbody              string   `protobuf:"bytes,4,opt,name=msgbody,proto3" json:"msgbody,omitempty"`
	Msgtype              uint32   `protobuf:"varint,5,opt,name=msgtype,proto3" json:"msgtype,omitempty"`
	Time                 uint32   `protobuf:"varint,6,opt,name=time,proto3" json:"time,omitempty"`
	XXX_NoUnkeyedLiteral struct{} `json:"-"`
	XXX_unrecognized     []byte   `json:"-"`
	XXX_sizecache        int32    `json:"-"`
}

func (m *GroupMessage) Reset()         { *m = GroupMessage{} }
func (m *GroupMessage) String() string { return proto.CompactTextString(m) }
func (*GroupMessage) ProtoMessage()    {}
func (*GroupMessage) Descriptor() ([]byte, []int) {
	return fileDescriptor_33c57e4bae7b9afd, []int{1}
}

func (m *GroupMessage) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_GroupMessage.Unmarshal(m, b)
}
func (m *GroupMessage) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_GroupMessage.Marshal(b, m, deterministic)
}
func (m *GroupMessage) XXX_Merge(src proto.Message) {
	xxx_messageInfo_GroupMessage.Merge(m, src)
}
func (m *GroupMessage) XXX_Size() int {
	return xxx_messageInfo_GroupMessage.Size(m)
}
func (m *GroupMessage) XXX_DiscardUnknown() {
	xxx_messageInfo_GroupMessage.DiscardUnknown(m)
}

var xxx_messageInfo_GroupMessage proto.InternalMessageInfo

func (m *GroupMessage) GetSender() uint32 {
	if m != nil {
		return m.Sender
	}
	return 0
}

func (m *GroupMessage) GetGroupid() uint32 {
	if m != nil {
		return m.Groupid
	}
	return 0
}

func (m *GroupMessage) GetMsgbody() string {
	if m != nil {
		return m.Msgbody
	}
	return ""
}

func (m *GroupMessage) GetMsgtype() uint32 {
	if m != nil {
		return m.Msgtype
	}
	return 0
}

func (m *GroupMessage) GetTime() uint32 {
	if m != nil {
		return m.Time
	}
	return 0
}

type AuthMessage struct {
	Token                string   `protobuf:"bytes,1,opt,name=token,proto3" json:"token,omitempty"`
	XXX_NoUnkeyedLiteral struct{} `json:"-"`
	XXX_unrecognized     []byte   `json:"-"`
	XXX_sizecache        int32    `json:"-"`
}

func (m *AuthMessage) Reset()         { *m = AuthMessage{} }
func (m *AuthMessage) String() string { return proto.CompactTextString(m) }
func (*AuthMessage) ProtoMessage()    {}
func (*AuthMessage) Descriptor() ([]byte, []int) {
	return fileDescriptor_33c57e4bae7b9afd, []int{2}
}

func (m *AuthMessage) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_AuthMessage.Unmarshal(m, b)
}
func (m *AuthMessage) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_AuthMessage.Marshal(b, m, deterministic)
}
func (m *AuthMessage) XXX_Merge(src proto.Message) {
	xxx_messageInfo_AuthMessage.Merge(m, src)
}
func (m *AuthMessage) XXX_Size() int {
	return xxx_messageInfo_AuthMessage.Size(m)
}
func (m *AuthMessage) XXX_DiscardUnknown() {
	xxx_messageInfo_AuthMessage.DiscardUnknown(m)
}

var xxx_messageInfo_AuthMessage proto.InternalMessageInfo

func (m *AuthMessage) GetToken() string {
	if m != nil {
		return m.Token
	}
	return ""
}

type AuthSuccessMessage struct {
	Status               uint32   `protobuf:"varint,1,opt,name=status,proto3" json:"status,omitempty"`
	XXX_NoUnkeyedLiteral struct{} `json:"-"`
	XXX_unrecognized     []byte   `json:"-"`
	XXX_sizecache        int32    `json:"-"`
}

func (m *AuthSuccessMessage) Reset()         { *m = AuthSuccessMessage{} }
func (m *AuthSuccessMessage) String() string { return proto.CompactTextString(m) }
func (*AuthSuccessMessage) ProtoMessage()    {}
func (*AuthSuccessMessage) Descriptor() ([]byte, []int) {
	return fileDescriptor_33c57e4bae7b9afd, []int{3}
}

func (m *AuthSuccessMessage) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_AuthSuccessMessage.Unmarshal(m, b)
}
func (m *AuthSuccessMessage) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_AuthSuccessMessage.Marshal(b, m, deterministic)
}
func (m *AuthSuccessMessage) XXX_Merge(src proto.Message) {
	xxx_messageInfo_AuthSuccessMessage.Merge(m, src)
}
func (m *AuthSuccessMessage) XXX_Size() int {
	return xxx_messageInfo_AuthSuccessMessage.Size(m)
}
func (m *AuthSuccessMessage) XXX_DiscardUnknown() {
	xxx_messageInfo_AuthSuccessMessage.DiscardUnknown(m)
}

var xxx_messageInfo_AuthSuccessMessage proto.InternalMessageInfo

func (m *AuthSuccessMessage) GetStatus() uint32 {
	if m != nil {
		return m.Status
	}
	return 0
}

type AckMessage struct {
	Rek                  uint64   `protobuf:"varint,1,opt,name=rek,proto3" json:"rek,omitempty"`
	Msgtype              uint32   `protobuf:"varint,2,opt,name=msgtype,proto3" json:"msgtype,omitempty"`
	Status               uint32   `protobuf:"varint,3,opt,name=status,proto3" json:"status,omitempty"`
	XXX_NoUnkeyedLiteral struct{} `json:"-"`
	XXX_unrecognized     []byte   `json:"-"`
	XXX_sizecache        int32    `json:"-"`
}

func (m *AckMessage) Reset()         { *m = AckMessage{} }
func (m *AckMessage) String() string { return proto.CompactTextString(m) }
func (*AckMessage) ProtoMessage()    {}
func (*AckMessage) Descriptor() ([]byte, []int) {
	return fileDescriptor_33c57e4bae7b9afd, []int{4}
}

func (m *AckMessage) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_AckMessage.Unmarshal(m, b)
}
func (m *AckMessage) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_AckMessage.Marshal(b, m, deterministic)
}
func (m *AckMessage) XXX_Merge(src proto.Message) {
	xxx_messageInfo_AckMessage.Merge(m, src)
}
func (m *AckMessage) XXX_Size() int {
	return xxx_messageInfo_AckMessage.Size(m)
}
func (m *AckMessage) XXX_DiscardUnknown() {
	xxx_messageInfo_AckMessage.DiscardUnknown(m)
}

var xxx_messageInfo_AckMessage proto.InternalMessageInfo

func (m *AckMessage) GetRek() uint64 {
	if m != nil {
		return m.Rek
	}
	return 0
}

func (m *AckMessage) GetMsgtype() uint32 {
	if m != nil {
		return m.Msgtype
	}
	return 0
}

func (m *AckMessage) GetStatus() uint32 {
	if m != nil {
		return m.Status
	}
	return 0
}

func init() {
	proto.RegisterType((*OneMessage)(nil), "intercom.OneMessage")
	proto.RegisterType((*GroupMessage)(nil), "intercom.GroupMessage")
	proto.RegisterType((*AuthMessage)(nil), "intercom.AuthMessage")
	proto.RegisterType((*AuthSuccessMessage)(nil), "intercom.AuthSuccessMessage")
	proto.RegisterType((*AckMessage)(nil), "intercom.AckMessage")
}

func init() { proto.RegisterFile("message.proto", fileDescriptor_33c57e4bae7b9afd) }

var fileDescriptor_33c57e4bae7b9afd = []byte{
	// 255 bytes of a gzipped FileDescriptorProto
	0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0xff, 0xac, 0x91, 0xc1, 0x4a, 0xc3, 0x40,
	0x10, 0x86, 0xd9, 0x26, 0x4d, 0xdb, 0xd1, 0x82, 0x2c, 0x22, 0x83, 0xa7, 0x10, 0x2f, 0x39, 0x88,
	0x17, 0x9f, 0xa0, 0x27, 0x4f, 0xa2, 0xc4, 0x27, 0x68, 0x37, 0x43, 0x0c, 0x21, 0xd9, 0xb0, 0x3b,
	0x11, 0xfa, 0x06, 0x3e, 0x83, 0x4f, 0x2b, 0x99, 0x66, 0x35, 0x1e, 0x7a, 0xf3, 0x36, 0x5f, 0xfe,
	0x3f, 0xc3, 0xc7, 0x2c, 0x6c, 0x5b, 0xf2, 0x7e, 0x5f, 0xd1, 0x43, 0xef, 0x2c, 0x5b, 0xbd, 0xae,
	0x3b, 0x26, 0x67, 0x6c, 0x9b, 0x7d, 0x29, 0x80, 0x97, 0x8e, 0x9e, 0x4f, 0xb1, 0xbe, 0x82, 0xc8,
	0x51, 0x83, 0x2a, 0x55, 0x79, 0x5c, 0x8c, 0xa3, 0xbe, 0x81, 0xc4, 0x53, 0x57, 0x92, 0xc3, 0x45,
	0xaa, 0xf2, 0x6d, 0x31, 0x91, 0xbe, 0x85, 0xb5, 0x23, 0x43, 0xf5, 0x07, 0x39, 0x8c, 0x24, 0xf9,
	0x61, 0x8d, 0xb0, 0x6a, 0x7d, 0x75, 0xb0, 0xe5, 0x11, 0xe3, 0x54, 0xe5, 0x9b, 0x22, 0xe0, 0x94,
	0xf0, 0xb1, 0x27, 0x5c, 0xca, 0x4f, 0x01, 0xb5, 0x86, 0x98, 0xeb, 0x96, 0x30, 0x91, 0xcf, 0x32,
	0x67, 0x9f, 0x0a, 0x2e, 0x9f, 0x9c, 0x1d, 0xfa, 0xa0, 0x77, 0x4e, 0x06, 0x61, 0x55, 0x8d, 0xbd,
	0xba, 0x9c, 0x5c, 0x02, 0xfe, 0x9b, 0xca, 0x1d, 0x5c, 0xec, 0x06, 0x7e, 0x0f, 0x22, 0xd7, 0xb0,
	0x64, 0xdb, 0x50, 0x27, 0x97, 0xda, 0x14, 0x27, 0xc8, 0xee, 0x41, 0x8f, 0xa5, 0xb7, 0xc1, 0x18,
	0xf2, 0x7e, 0x2e, 0xcd, 0x7b, 0x1e, 0xbc, 0x94, 0x47, 0x69, 0xa1, 0xec, 0x15, 0x60, 0x67, 0x9a,
	0xf3, 0x97, 0x9f, 0x09, 0x2e, 0xfe, 0x0a, 0xfe, 0x6e, 0x8c, 0xe6, 0x1b, 0x0f, 0x89, 0xbc, 0xee,
	0xe3, 0x77, 0x00, 0x00, 0x00, 0xff, 0xff, 0x20, 0x56, 0x7e, 0x77, 0xee, 0x01, 0x00, 0x00,
}
