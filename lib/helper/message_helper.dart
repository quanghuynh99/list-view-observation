import 'dart:math';

import 'package:ziichat_ui_v2/domain/mock_entities/mock_message_entity.dart';
import 'package:ziichat_ui_v2/domain/mock_entities/mock_user_entity.dart';

class MessageHelper {
  static String string(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  static MessageEntity mockBaseMessage = MessageEntity(
    messageId: string(16),
    content: '''
  This is a mock message https://wwww.google.com for long text @LeonardoABC that might overflow the screen
  and still be readable. This is my test message. This is my test message for
''',
    user: UserEntity(
        userId: '1',
        username: "Wade Warren",
        avatarUrl: 'https://picsum.photos/60/60'),
    reactions: [""],
    messageType: MessageType.text,
    updateTime: "05:00 AM",
    isEdited: true,
    isOutgoing: Random().nextBool(),
  );

  static MessageEntity originalMessage = MessageEntity(
      messageId: string(16),
      messageType: MessageType.text,
      updateTime: 'updateTime',
      content: "ABC send a sticker",
      isOutgoing: Random().nextBool(),
      user: UserEntity(
          userId: "userId",
          username: "ABC",
          avatarUrl: 'https://picsum.photos/id/255/36/36'));

  static EmbedInfo embedInfo = EmbedInfo(
      url: 'https://picsum.photos/id/99/150/200',
      title: "Grand Opening Hahalolo | News Landing page in 2022.",
      description:
          'After four years of operation, the travel social network Hahalolo has reached milestones ...',
      thumbnailUrl: 'https://picsum.photos/id/99/150/200');

  static List<MessageEntity> mockMessages({int num = 10}) {
    return List.generate(num, (index) {
      final type =
          MessageType.values[Random().nextInt(MessageType.values.length)];
      final messageId = string(16);
      switch (type) {
        case MessageType.text:
          return mockBaseMessage.copyWith(
            messageId: messageId,
            type: type,
            content: string(16),
            originalMessage: Random().nextBool() ? originalMessage : null,
            embedInfo: Random().nextBool() ? embedInfo : null,
          );
        case MessageType.image:
          final attachments = List.generate(Random().nextInt(3) + 1, (index) {
            return Attachments(
              url: 'https://picsum.photos/id/${15 + index}/150/200',
              thumbnailUrl: 'https://picsum.photos/id/${15 + index}/150/200',
            );
          });
          return mockBaseMessage.copyWith(
            messageId: messageId,
            attachments: attachments,
            type: type,
          );
        case MessageType.video:
        case MessageType.videoAttachment:
        case MessageType.sticker:
        case MessageType.wave:
          return mockBaseMessage.copyWith(
            messageId: messageId,
            attachments: [
              Attachments(
                url: 'https://picsum.photos/id/60/150/200',
                thumbnailUrl: 'https://picsum.photos/id/60/150/200',
              ),
            ],
            type: type,
          );
        case MessageType.audio:
          return mockBaseMessage.copyWith(
            messageId: messageId,
            type: type,
            attachments: [
              Attachments(
                url:
                    'https://cdn.pixabay.com/download/audio/2024/03/18/audio_b71ef0cb1f.mp3',
                thumbnailUrl:
                    'https://cdn.pixabay.com/download/audio/2024/03/18/audio_b71ef0cb1f.mp3',
              ),
            ],
          );
        case MessageType.system:
          return mockBaseMessage.copyWith(
            messageId: messageId,
            type: type,
            content: 'This is a System message',
          );
        case MessageType.joinMember:
          return mockBaseMessage.copyWith(
            messageId: messageId,
            type: type,
          );
      }
    });
  }

  static List<MessageEntity> mockMessages1 = List.generate(10, (index) {
    final type =
        MessageType.values[Random().nextInt(MessageType.values.length)];

    switch (type) {
      case MessageType.text:
        return mockBaseMessage.copyWith(
          messageId: string(16),
          type: type,
          originalMessage: Random().nextBool() ? originalMessage : null,
          embedInfo: Random().nextBool() ? embedInfo : null,
        );
      case MessageType.image:
        final attachments = List.generate(Random().nextInt(9) + 1, (index) {
          return Attachments(
              url: "https://picsum.photos/id/15/150/200",
              thumbnailUrl: "https://picsum.photos/id/15/150/200");
        });
        return mockBaseMessage.copyWith(attachments: attachments, type: type);
      case MessageType.video:
      case MessageType.videoAttachment:
      case MessageType.sticker:
      case MessageType.wave:
        return mockBaseMessage.copyWith(
          attachments: [
            Attachments(
                url: "https://picsum.photos/id/60/150/200",
                thumbnailUrl: "https://picsum.photos/id/60/150/200")
          ],
          type: type,
        );
      case MessageType.audio:
        return mockBaseMessage.copyWith(type: type, attachments: [
          Attachments(
              url:
                  'https://cdn.pixabay.com/download/audio/2024/03/18/audio_b71ef0cb1f.mp3?filename=17-3-2024-bon-choix-de-sa-vie-loin-de-son-ame-soeur-196818.mp3',
              thumbnailUrl:
                  'https://cdn.pixabay.com/download/audio/2024/03/18/audio_b71ef0cb1f.mp3?filename=17-3-2024-bon-choix-de-sa-vie-loin-de-son-ame-soeur-196818.mp3')
        ]);
      case MessageType.system:
        return mockBaseMessage.copyWith(
            type: type, content: 'This is a System message');
      case MessageType.joinMember:
        return mockBaseMessage.copyWith(type: type);
    }
  });
}
