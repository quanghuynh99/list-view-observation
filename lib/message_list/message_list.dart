import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:ziichat_ui_v2/domain/mock_entities/mock_file_metadata.dart';
import 'package:ziichat_ui_v2/domain/mock_entities/mock_message_entity.dart';
import 'package:ziichat_ui_v2/domain/mock_entities/mock_user_entity.dart';
import 'package:ziichat_ui_v2/page/chats/editor/editor.dart';
import 'package:ziichat_ui_v2/page/chats/message_list/message_items/join_message.dart';
import 'package:ziichat_ui_v2/page/chats/message_list/message_items/photo_message.dart';
import 'package:ziichat_ui_v2/page/chats/message_list/message_items/sticker_message.dart';
import 'package:ziichat_ui_v2/page/chats/message_list/message_items/system_message.dart';
import 'package:ziichat_ui_v2/page/chats/message_list/message_items/text_message.dart';
import 'package:ziichat_ui_v2/page/chats/message_list/message_items/video_message.dart';
import 'package:ziichat_ui_v2/page/chats/message_list/message_items/voice_message.dart';
import 'package:ziichat_ui_v2/page/chats/message_list/message_items/wave_message.dart';
import 'package:ziichat_ui_v2/page/chats/message_list/widget/channel_navigation_bar.dart';
import 'package:ziichat_ui_v2/utils/constants/enum.dart';
import 'package:ziichat_ui_v2/utils/constants/sizes.dart';

class MessageList extends StatefulWidget {
  final Function? onChannelSetting;
  final List<MessageEntity> messages;
  final List<FileData> fileList;

  final String? imageUrl;
  final Widget? defaultImage;
  final String title;
  final String subTitle;
  final ChannelTitleState? state;

  late TextEditingController textEditingController;

  MessageList({
    super.key,
    this.imageUrl,
    this.defaultImage,
    this.onChannelSetting,
    this.state,
    required this.title,
    required this.subTitle,
    required this.fileList,
    required this.messages,
    required this.textEditingController,
  });

  @override
  State<MessageList> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageList> {
  late ListObserverController _listObserverController;
  late ChatScrollObserver _chatScrollObserver;
  late ScrollController scrollController = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _listObserverController =
        ListObserverController(controller: scrollController)
          ..cacheJumpIndexOffset = false;
    _chatScrollObserver = ChatScrollObserver(_listObserverController)
      ..fixedPositionOffset = 5
      ..toRebuildScrollViewCallback = () {
        setState(() {});
      };

    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _chatScrollObserver.standby();
      setState(() {
        widget.messages.insert(0, _generateRandomMessage());
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    scrollController.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    if (widget.messages.isNotEmpty) {
      _listObserverController.jumpTo(index: widget.messages.length - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChannelNavigationBar(
        imageUrl: widget.imageUrl,
        defaultImage: widget.defaultImage,
        title: widget.title,
        subTitle: widget.subTitle,
        state: widget.state,
        onChannelSetting: () {
          widget.onChannelSetting?.call();
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              thickness: ZSizes.sm,
              radius: const Radius.circular(12),
              thumbVisibility: true,
              interactive: true,
              child: ListViewObserver(
                controller: _listObserverController,
                child: ListView.builder(
                  controller: scrollController,
                  physics: ChatObserverClampingScrollPhysics(
                      observer: _chatScrollObserver),
                  shrinkWrap: _chatScrollObserver.isShrinkWrap,
                  reverse: true,
                  itemCount: widget.messages.length,
                  itemBuilder: (context, index) {
                    return ConstrainedBox(
                      key: ValueKey(widget.messages[index].messageId),
                      constraints: const BoxConstraints(
                        minWidth: ZSizes.embedWidth,
                        maxWidth: ZSizes.messagesPageMaxWidth,
                      ),
                      child: Padding(
                        padding: ZSizes.messageInsets,
                        child: renderMessageNewest(widget.messages[index]),
                      ),
                    );
                  },
                ),
                onObserve: (resultModel) {
                  // debugPrint('Các mục hiển thị: $resultModel');
                },
              ),
            ),
          ),
          Editor(
            fileList: widget.fileList,
            textEditingController: widget.textEditingController,
            didTapEmojiButton: () {},
            didTapFileButton: () {},
            didTapSendButton: (_) {},
            didTapRemoveAll: () {},
            didDeleteItem: (_) {},
          ),
        ],
      ),
    );
  }
}

Widget renderMessageNewest(MessageEntity messageEntity) {
  switch (messageEntity.messageType) {
    case MessageType.text:
      return TextMessage(messageEntity: messageEntity);
    case MessageType.sticker:
      return StickerMessage(messageEntity: messageEntity);
    case MessageType.image:
      return PhotoMessage(messageEntity: messageEntity);
    case MessageType.video || MessageType.videoAttachment:
      return VideoMessage(messageEntity: messageEntity);
    case MessageType.audio:
      return VoiceMessage(messageEntity: messageEntity);
    case MessageType.system:
      return SystemMessage(messageEntity: messageEntity);
    case MessageType.wave:
      return WaveMessage(messageEntity: messageEntity);
    case MessageType.joinMember:
      return JoinMemberMessage(messageEntity: messageEntity);
  }
}

// *  ------------------------------------------- MARK: MOCK DATA ----------------------------------------------------
// *
// *
// *
// *
// *
// *
// *
final me = UserEntity(
  username: 'Message incoming',
  avatarUrl: 'https://picsum.photos/id/23/56/56',
  userId: '1',
);
final other = UserEntity(
  username: 'Message outgoing',
  avatarUrl: 'https://picsum.photos/id/56/56/56',
  userId: '2',
);

MessageEntity _generateRandomMessage() {
  final random = Random();
  final messageType =
      MessageType.values[random.nextInt(MessageType.values.length)];
  // final messageType = MessageType.text;
  final isOutgoing = random.nextBool();
  UserEntity? user;

  if (messageType == MessageType.system ||
      messageType == MessageType.joinMember) {
    user = null;
  } else {
    user = isOutgoing ? me : other;
  }

  final now = DateTime.now();
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final formattedDate =
      '${twoDigits(now.day)}/${twoDigits(now.month)}/${now.year} '
      '${twoDigits(now.hour)}:${twoDigits(now.minute)}:${twoDigits(now.second)}';

  String? content;
  List<Attachments>? attachments;

  switch (messageType) {
    case MessageType.text:
      content =
          'Xin chào từ ${user?.username ?? "Hệ thống"} lúc $formattedDate';
      break;
    case MessageType.image:
      attachments = [
        Attachments(
          url: 'https://picsum.photos/200/300?random=${random.nextInt(1000)}',
          thumbnailUrl:
              'https://picsum.photos/200/300?random=${random.nextInt(1000)}',
        ),
      ];
      break;
    case MessageType.video:
      attachments = [
        Attachments(
          url: 'https://picsum.photos/200/300?random=${random.nextInt(1000)}',
          thumbnailUrl:
              'https://picsum.photos/200/300?random=${random.nextInt(1000)}',
        ),
      ];
      break;
    case MessageType.videoAttachment:
      attachments = [
        Attachments(
          url: 'https://picsum.photos/200/300?random=${random.nextInt(1000)}',
          thumbnailUrl:
              'https://picsum.photos/200/300?random=${random.nextInt(1000)}',
        ),
      ];
      break;
    case MessageType.audio:
      content = 'Tin nhắn âm thanh';
      break;
    case MessageType.sticker:
      content = 'Sticker ID: sticker_${random.nextInt(100)}';
      break;
    case MessageType.system:
      content = 'Thông báo hệ thống lúc $formattedDate';
      break;
    case MessageType.wave:
      content = 'Tin nhắn vẫy tay';
      break;
    case MessageType.joinMember:
      content = '${other.username} đã tham gia kênh';
      break;
  }

  return MessageEntity(
    messageId: DateTime.now().toString(),
    content: content,
    messageType: messageType,
    updateTime: formattedDate,
    user: user,
    attachments: attachments,
    isOutgoing: isOutgoing,
    messageState: MessageState.sent,
    originalMessage: Random().nextInt(10) == 9
        ? MessageEntity(
            messageId: DateTime.now().toString(),
            messageType: MessageType.text,
            updateTime: 'updateTime $formattedDate',
            isOutgoing: true,
            content: "content of quote")
        : null,
    seen: false,
  );
}
