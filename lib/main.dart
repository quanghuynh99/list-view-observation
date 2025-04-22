import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:list_view/helper/message_helper.dart';
import 'package:list_view/message_list/message_list_page.dart';
import 'package:ziichat_ui_v2/page/chats/message_list/message_items/message.dart';
import 'package:ziichat_ui_v2/utils/theme/app_theme.dart';
import 'package:ziichat_ui_v2/ziichat_ui_v2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<ChatPagedListViewState<MessageEntity>> _chatListKey =
      GlobalKey<ChatPagedListViewState<MessageEntity>>();
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      theme: AppTheme.lightTheme,
      home: MessageListPage<MessageEntity>(
        key: _chatListKey,
        itemBuilder: (context, model, _) => renderMessage(model),
        createItems: MessageHelper.mockMessages,
        itemKeyExtractor: (chatModel) => chatModel.messageId,
      ),
    );
  }

  Widget renderMessage(MessageEntity messageEntity) {
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
}
