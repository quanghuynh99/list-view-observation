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

  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

  Lorem ipsum dolor sit https://picsum.photos/id/300/36/36, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
Apart from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. To check word count, simply place your cursor into the text box above and start typing. You'll see the number of characters and words increase or decrease as you type, delete, and edit them. You can also copy and paste text from another program over into the online editor above. The Auto-Save feature will make sure you won't lose any changes while editing, even if you leave the site and come back later. Tip: Bookmark this page now.

Knowing the word count of a text can be important. For example, if an @abc.com has to write a minimum or maximum amount of words for an article, essay, report, story, book, paper, you name it. WordCounter will help to make sure its word count reaches a specific requirement or stays within a certain limit.

In addition, WordCounter abc.com keywords and keyword @density of the article you're writing. This allows you to know which keywords you use how often and at what percentages. This can prevent you from over-using certain words or word combinations and check for best distribution of keywords in your writing.

In the Details overview you can see the average speaking and @11122335 time for your text, while Reading Level is an indicator of the education level a person would need in order to understand the words you’re using.
.. you can check this  
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

  // final List<FileData> mocksFile = List.generate(10, (index) {
  //   final type = FileType.values[Random().nextInt(FileType.values.length)];
  //   switch (type) {
  //     case FileType.video:
  //       return FileData(
  //           id: 'id', name: 'video file name', path: '', type: type);
  //     case FileType.image:
  //       return FileData(id: 'id', name: 'file name', path: '', type: type);
  //     case FileType.file:
  //       return FileData(
  //           id: 'id', name: 'photo file name', path: '', type: type);
  //   }
  // });

  static List<MessageEntity> mockMessages = List.generate(50, (index) {
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
        // return mockBaseMessage.copyWith(type: type);
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
