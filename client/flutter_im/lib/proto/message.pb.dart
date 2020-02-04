///
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class OneMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('OneMessage', package: const $pb.PackageName('intercom'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'rek', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(2, 'sender', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, 'receiver', $pb.PbFieldType.OU3)
    ..aOS(4, 'msgbody')
    ..a<$core.int>(5, 'msgtype', $pb.PbFieldType.OU3)
    ..a<$core.int>(6, 'time', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  OneMessage._() : super();
  factory OneMessage() => create();
  factory OneMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OneMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  OneMessage clone() => OneMessage()..mergeFromMessage(this);
  OneMessage copyWith(void Function(OneMessage) updates) => super.copyWith((message) => updates(message as OneMessage));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OneMessage create() => OneMessage._();
  OneMessage createEmptyInstance() => create();
  static $pb.PbList<OneMessage> createRepeated() => $pb.PbList<OneMessage>();
  @$core.pragma('dart2js:noInline')
  static OneMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OneMessage>(create);
  static OneMessage _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get rek => $_getI64(0);
  @$pb.TagNumber(1)
  set rek($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRek() => $_has(0);
  @$pb.TagNumber(1)
  void clearRek() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get sender => $_getIZ(1);
  @$pb.TagNumber(2)
  set sender($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSender() => $_has(1);
  @$pb.TagNumber(2)
  void clearSender() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get receiver => $_getIZ(2);
  @$pb.TagNumber(3)
  set receiver($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasReceiver() => $_has(2);
  @$pb.TagNumber(3)
  void clearReceiver() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get msgbody => $_getSZ(3);
  @$pb.TagNumber(4)
  set msgbody($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMsgbody() => $_has(3);
  @$pb.TagNumber(4)
  void clearMsgbody() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get msgtype => $_getIZ(4);
  @$pb.TagNumber(5)
  set msgtype($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMsgtype() => $_has(4);
  @$pb.TagNumber(5)
  void clearMsgtype() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get time => $_getIZ(5);
  @$pb.TagNumber(6)
  set time($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearTime() => clearField(6);
}

class GroupMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GroupMessage', package: const $pb.PackageName('intercom'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'rek', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(2, 'sender', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, 'groupid', $pb.PbFieldType.OU3)
    ..aOS(4, 'msgbody')
    ..a<$core.int>(5, 'msgtype', $pb.PbFieldType.OU3)
    ..a<$core.int>(6, 'time', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  GroupMessage._() : super();
  factory GroupMessage() => create();
  factory GroupMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GroupMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  GroupMessage clone() => GroupMessage()..mergeFromMessage(this);
  GroupMessage copyWith(void Function(GroupMessage) updates) => super.copyWith((message) => updates(message as GroupMessage));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GroupMessage create() => GroupMessage._();
  GroupMessage createEmptyInstance() => create();
  static $pb.PbList<GroupMessage> createRepeated() => $pb.PbList<GroupMessage>();
  @$core.pragma('dart2js:noInline')
  static GroupMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GroupMessage>(create);
  static GroupMessage _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get rek => $_getI64(0);
  @$pb.TagNumber(1)
  set rek($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRek() => $_has(0);
  @$pb.TagNumber(1)
  void clearRek() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get sender => $_getIZ(1);
  @$pb.TagNumber(2)
  set sender($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSender() => $_has(1);
  @$pb.TagNumber(2)
  void clearSender() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get groupid => $_getIZ(2);
  @$pb.TagNumber(3)
  set groupid($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasGroupid() => $_has(2);
  @$pb.TagNumber(3)
  void clearGroupid() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get msgbody => $_getSZ(3);
  @$pb.TagNumber(4)
  set msgbody($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMsgbody() => $_has(3);
  @$pb.TagNumber(4)
  void clearMsgbody() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get msgtype => $_getIZ(4);
  @$pb.TagNumber(5)
  set msgtype($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMsgtype() => $_has(4);
  @$pb.TagNumber(5)
  void clearMsgtype() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get time => $_getIZ(5);
  @$pb.TagNumber(6)
  set time($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearTime() => clearField(6);
}

class AuthMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AuthMessage', package: const $pb.PackageName('intercom'), createEmptyInstance: create)
    ..aOS(1, 'token')
    ..hasRequiredFields = false
  ;

  AuthMessage._() : super();
  factory AuthMessage() => create();
  factory AuthMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  AuthMessage clone() => AuthMessage()..mergeFromMessage(this);
  AuthMessage copyWith(void Function(AuthMessage) updates) => super.copyWith((message) => updates(message as AuthMessage));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AuthMessage create() => AuthMessage._();
  AuthMessage createEmptyInstance() => create();
  static $pb.PbList<AuthMessage> createRepeated() => $pb.PbList<AuthMessage>();
  @$core.pragma('dart2js:noInline')
  static AuthMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthMessage>(create);
  static AuthMessage _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);
}

class AuthSuccessMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AuthSuccessMessage', package: const $pb.PackageName('intercom'), createEmptyInstance: create)
    ..a<$core.int>(1, 'status', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  AuthSuccessMessage._() : super();
  factory AuthSuccessMessage() => create();
  factory AuthSuccessMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthSuccessMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  AuthSuccessMessage clone() => AuthSuccessMessage()..mergeFromMessage(this);
  AuthSuccessMessage copyWith(void Function(AuthSuccessMessage) updates) => super.copyWith((message) => updates(message as AuthSuccessMessage));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AuthSuccessMessage create() => AuthSuccessMessage._();
  AuthSuccessMessage createEmptyInstance() => create();
  static $pb.PbList<AuthSuccessMessage> createRepeated() => $pb.PbList<AuthSuccessMessage>();
  @$core.pragma('dart2js:noInline')
  static AuthSuccessMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthSuccessMessage>(create);
  static AuthSuccessMessage _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get status => $_getIZ(0);
  @$pb.TagNumber(1)
  set status($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
}

class AckMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AckMessage', package: const $pb.PackageName('intercom'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'rek', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(2, 'msgtype', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, 'status', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  AckMessage._() : super();
  factory AckMessage() => create();
  factory AckMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AckMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  AckMessage clone() => AckMessage()..mergeFromMessage(this);
  AckMessage copyWith(void Function(AckMessage) updates) => super.copyWith((message) => updates(message as AckMessage));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AckMessage create() => AckMessage._();
  AckMessage createEmptyInstance() => create();
  static $pb.PbList<AckMessage> createRepeated() => $pb.PbList<AckMessage>();
  @$core.pragma('dart2js:noInline')
  static AckMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AckMessage>(create);
  static AckMessage _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get rek => $_getI64(0);
  @$pb.TagNumber(1)
  set rek($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRek() => $_has(0);
  @$pb.TagNumber(1)
  void clearRek() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get msgtype => $_getIZ(1);
  @$pb.TagNumber(2)
  set msgtype($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMsgtype() => $_has(1);
  @$pb.TagNumber(2)
  void clearMsgtype() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get status => $_getIZ(2);
  @$pb.TagNumber(3)
  set status($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => clearField(3);
}

class PullOneMessages extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PullOneMessages', package: const $pb.PackageName('intercom'), createEmptyInstance: create)
    ..pc<OneMessage>(1, 'messages', $pb.PbFieldType.PM, subBuilder: OneMessage.create)
    ..hasRequiredFields = false
  ;

  PullOneMessages._() : super();
  factory PullOneMessages() => create();
  factory PullOneMessages.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PullOneMessages.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PullOneMessages clone() => PullOneMessages()..mergeFromMessage(this);
  PullOneMessages copyWith(void Function(PullOneMessages) updates) => super.copyWith((message) => updates(message as PullOneMessages));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PullOneMessages create() => PullOneMessages._();
  PullOneMessages createEmptyInstance() => create();
  static $pb.PbList<PullOneMessages> createRepeated() => $pb.PbList<PullOneMessages>();
  @$core.pragma('dart2js:noInline')
  static PullOneMessages getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PullOneMessages>(create);
  static PullOneMessages _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<OneMessage> get messages => $_getList(0);
}

class PullGroupMessages extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PullGroupMessages', package: const $pb.PackageName('intercom'), createEmptyInstance: create)
    ..pc<GroupMessage>(1, 'messages', $pb.PbFieldType.PM, subBuilder: GroupMessage.create)
    ..hasRequiredFields = false
  ;

  PullGroupMessages._() : super();
  factory PullGroupMessages() => create();
  factory PullGroupMessages.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PullGroupMessages.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PullGroupMessages clone() => PullGroupMessages()..mergeFromMessage(this);
  PullGroupMessages copyWith(void Function(PullGroupMessages) updates) => super.copyWith((message) => updates(message as PullGroupMessages));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PullGroupMessages create() => PullGroupMessages._();
  PullGroupMessages createEmptyInstance() => create();
  static $pb.PbList<PullGroupMessages> createRepeated() => $pb.PbList<PullGroupMessages>();
  @$core.pragma('dart2js:noInline')
  static PullGroupMessages getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PullGroupMessages>(create);
  static PullGroupMessages _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<GroupMessage> get messages => $_getList(0);
}

class AckManyMesasges extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AckManyMesasges', package: const $pb.PackageName('intercom'), createEmptyInstance: create)
    ..p<$fixnum.Int64>(1, 'reks', $pb.PbFieldType.PU6)
    ..a<$core.int>(2, 'msgtype', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, 'status', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  AckManyMesasges._() : super();
  factory AckManyMesasges() => create();
  factory AckManyMesasges.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AckManyMesasges.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  AckManyMesasges clone() => AckManyMesasges()..mergeFromMessage(this);
  AckManyMesasges copyWith(void Function(AckManyMesasges) updates) => super.copyWith((message) => updates(message as AckManyMesasges));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AckManyMesasges create() => AckManyMesasges._();
  AckManyMesasges createEmptyInstance() => create();
  static $pb.PbList<AckManyMesasges> createRepeated() => $pb.PbList<AckManyMesasges>();
  @$core.pragma('dart2js:noInline')
  static AckManyMesasges getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AckManyMesasges>(create);
  static AckManyMesasges _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$fixnum.Int64> get reks => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get msgtype => $_getIZ(1);
  @$pb.TagNumber(2)
  set msgtype($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMsgtype() => $_has(1);
  @$pb.TagNumber(2)
  void clearMsgtype() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get status => $_getIZ(2);
  @$pb.TagNumber(3)
  set status($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => clearField(3);
}

class DeleteManyMessages extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DeleteManyMessages', package: const $pb.PackageName('intercom'), createEmptyInstance: create)
    ..p<$fixnum.Int64>(1, 'reks', $pb.PbFieldType.PU6)
    ..a<$core.int>(2, 'msgtype', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  DeleteManyMessages._() : super();
  factory DeleteManyMessages() => create();
  factory DeleteManyMessages.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteManyMessages.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  DeleteManyMessages clone() => DeleteManyMessages()..mergeFromMessage(this);
  DeleteManyMessages copyWith(void Function(DeleteManyMessages) updates) => super.copyWith((message) => updates(message as DeleteManyMessages));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeleteManyMessages create() => DeleteManyMessages._();
  DeleteManyMessages createEmptyInstance() => create();
  static $pb.PbList<DeleteManyMessages> createRepeated() => $pb.PbList<DeleteManyMessages>();
  @$core.pragma('dart2js:noInline')
  static DeleteManyMessages getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteManyMessages>(create);
  static DeleteManyMessages _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$fixnum.Int64> get reks => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get msgtype => $_getIZ(1);
  @$pb.TagNumber(2)
  set msgtype($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMsgtype() => $_has(1);
  @$pb.TagNumber(2)
  void clearMsgtype() => clearField(2);
}

