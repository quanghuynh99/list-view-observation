import 'package:flutter/material.dart';
import 'package:list_view/helper/message_helper.dart';
import 'package:list_view/message_list/message_list_page.dart';
import 'package:ziichat_ui_v2/domain/mock_entities/mock_message_entity.dart';
import 'package:ziichat_ui_v2/page/chats/message_list/message_items/join_message.dart';
import 'package:ziichat_ui_v2/page/chats/message_list/message_items/photo_message.dart';
import 'package:ziichat_ui_v2/page/chats/message_list/message_items/sticker_message.dart';
import 'package:ziichat_ui_v2/page/chats/message_list/message_items/system_message.dart';
import 'package:ziichat_ui_v2/page/chats/message_list/message_items/text_message.dart';
import 'package:ziichat_ui_v2/page/chats/message_list/message_items/video_message.dart';
import 'package:ziichat_ui_v2/page/chats/message_list/message_items/voice_message.dart';
import 'package:ziichat_ui_v2/page/chats/message_list/message_items/wave_message.dart';

class Home extends StatelessWidget {
  final GlobalKey<ChatPagedListViewState<MessageEntity>> _chatListKey =
      GlobalKey<ChatPagedListViewState<MessageEntity>>();
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MessageListPage<MessageEntity>(
        key: _chatListKey,
        itemBuilder: (context, model, _) => renderMessage(model),
        createItems: MessageHelper.mockMessages(num: 10),
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
