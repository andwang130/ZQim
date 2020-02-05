///
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const OneMessage$json = const {
  '1': 'OneMessage',
  '2': const [
    const {'1': 'rek', '3': 1, '4': 1, '5': 4, '10': 'rek'},
    const {'1': 'sender', '3': 2, '4': 1, '5': 13, '10': 'sender'},
    const {'1': 'receiver', '3': 3, '4': 1, '5': 13, '10': 'receiver'},
    const {'1': 'msgbody', '3': 4, '4': 1, '5': 9, '10': 'msgbody'},
    const {'1': 'msgtype', '3': 5, '4': 1, '5': 13, '10': 'msgtype'},
    const {'1': 'time', '3': 6, '4': 1, '5': 13, '10': 'time'},
  ],
};

const GroupMessage$json = const {
  '1': 'GroupMessage',
  '2': const [
    const {'1': 'rek', '3': 1, '4': 1, '5': 4, '10': 'rek'},
    const {'1': 'sender', '3': 2, '4': 1, '5': 13, '10': 'sender'},
    const {'1': 'groupid', '3': 3, '4': 1, '5': 13, '10': 'groupid'},
    const {'1': 'msgbody', '3': 4, '4': 1, '5': 9, '10': 'msgbody'},
    const {'1': 'msgtype', '3': 5, '4': 1, '5': 13, '10': 'msgtype'},
    const {'1': 'time', '3': 6, '4': 1, '5': 13, '10': 'time'},
  ],
};

const AuthMessage$json = const {
  '1': 'AuthMessage',
  '2': const [
    const {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
  ],
};

const AuthSuccessMessage$json = const {
  '1': 'AuthSuccessMessage',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 13, '10': 'status'},
  ],
};

const AckMessage$json = const {
  '1': 'AckMessage',
  '2': const [
    const {'1': 'rek', '3': 1, '4': 1, '5': 4, '10': 'rek'},
    const {'1': 'msgtype', '3': 2, '4': 1, '5': 13, '10': 'msgtype'},
    const {'1': 'status', '3': 3, '4': 1, '5': 13, '10': 'status'},
  ],
};

const PullOneMessages$json = const {
  '1': 'PullOneMessages',
  '2': const [
    const {'1': 'messages', '3': 1, '4': 3, '5': 11, '6': '.intercom.OneMessage', '10': 'messages'},
  ],
};

const PullGroupMessages$json = const {
  '1': 'PullGroupMessages',
  '2': const [
    const {'1': 'messages', '3': 1, '4': 3, '5': 11, '6': '.intercom.GroupMessage', '10': 'messages'},
  ],
};

const PullNotifieMessage$json = const {
  '1': 'PullNotifieMessage',
  '2': const [
    const {'1': 'messages', '3': 1, '4': 3, '5': 11, '6': '.intercom.Notify', '10': 'messages'},
  ],
};

const AckManyMesasges$json = const {
  '1': 'AckManyMesasges',
  '2': const [
    const {'1': 'reks', '3': 1, '4': 3, '5': 4, '10': 'reks'},
    const {'1': 'msgtype', '3': 2, '4': 1, '5': 13, '10': 'msgtype'},
    const {'1': 'status', '3': 3, '4': 1, '5': 13, '10': 'status'},
  ],
};

const DeleteManyMessages$json = const {
  '1': 'DeleteManyMessages',
  '2': const [
    const {'1': 'reks', '3': 1, '4': 3, '5': 4, '10': 'reks'},
    const {'1': 'msgtype', '3': 2, '4': 1, '5': 13, '10': 'msgtype'},
  ],
};

const Notify$json = const {
  '1': 'Notify',
  '2': const [
    const {'1': 'notifieType', '3': 1, '4': 1, '5': 13, '10': 'notifieType'},
    const {'1': 'body', '3': 2, '4': 1, '5': 12, '10': 'body'},
  ],
};

const Agree$json = const {
  '1': 'Agree',
  '2': const [
    const {'1': 'notife', '3': 1, '4': 1, '5': 11, '6': '.intercom.FriendNotife', '10': 'notife'},
  ],
};

const FriendNotife$json = const {
  '1': 'FriendNotife',
  '2': const [
    const {'1': 'greet', '3': 1, '4': 1, '5': 9, '10': 'greet'},
    const {'1': 'uid', '3': 2, '4': 1, '5': 13, '10': 'uid'},
    const {'1': 'receiver', '3': 3, '4': 1, '5': 13, '10': 'receiver'},
    const {'1': 'nid', '3': 4, '4': 1, '5': 13, '10': 'nid'},
  ],
};

