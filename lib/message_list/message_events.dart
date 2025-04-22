import 'package:ziichat_ui_v2/domain/mock_entities/mock_message_entity.dart';

abstract class ChatEvent {}

class LoadInitialMessages extends ChatEvent {}

class FetchPage extends ChatEvent {
  final int pageKey;

  FetchPage(this.pageKey);
}

class ToggleHeaderFooterStyle extends ChatEvent {}

class ToggleEditReadOnly extends ChatEvent {}

class AddMessage extends ChatEvent {
  final List<MessageEntity> messages;
  AddMessage(this.messages);
}

class UpdateUnreadMsgCount extends ChatEvent {
  final bool isReset;
  final int changeCount;
  UpdateUnreadMsgCount({this.isReset = false, this.changeCount = 1});
}

class ChatState<T> {
  final bool needIncrementUnreadMsgCount;
  final bool editViewReadOnly;
  final bool isLoading;
  final List<T>? messages;
  final int unreadMsgCount;
  final String? error;
  final bool showUnreadTip;

  ChatState({
    this.needIncrementUnreadMsgCount = false,
    this.editViewReadOnly = false,
    this.isLoading = false,
    this.messages,
    this.unreadMsgCount = 0,
    this.error,
    this.showUnreadTip = false,
  });

  ChatState<T> copyWith({
    bool? needIncrementUnreadMsgCount,
    bool? editViewReadOnly,
    bool? isLoading,
    List<T>? messages,
    int? unreadMsgCount,
    String? error,
    bool? showUnreadTip,
  }) {
    return ChatState<T>(
      needIncrementUnreadMsgCount:
          needIncrementUnreadMsgCount ?? this.needIncrementUnreadMsgCount,
      editViewReadOnly: editViewReadOnly ?? this.editViewReadOnly,
      isLoading: isLoading ?? this.isLoading,
      messages: messages ?? this.messages,
      unreadMsgCount: unreadMsgCount ?? this.unreadMsgCount,
      error: error ?? this.error,
      showUnreadTip: showUnreadTip ?? this.showUnreadTip,
    );
  }
}
