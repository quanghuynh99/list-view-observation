import 'dart:math';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:list_view/helper/message_helper.dart';
import 'package:list_view/message_list/message_events.dart';
import 'package:list_view/widgets/unread_view.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:ziichat_ui_v2/domain/mock_entities/mock_message_entity.dart';
import 'package:ziichat_ui_v2/page/chats/editor/editor.dart';
import 'package:ziichat_ui_v2/ziichat_ui_v2.dart';

class MessageListPage<T> extends StatefulWidget {
  final Widget Function(BuildContext, T, int) itemBuilder;
  final String Function(T)? itemKeyExtractor;
  final void Function(int)? onRemove;
  final List<T> createItems;

  const MessageListPage({
    super.key,
    required this.itemBuilder,
    required this.createItems,
    this.itemKeyExtractor,
    this.onRemove,
  });

  @override
  State<MessageListPage<T>> createState() => ChatPagedListViewState<T>();
}

class ChatPagedListViewState<T> extends State<MessageListPage<T>>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final ScrollController scrollController = ScrollController();
  late ListObserverController observerController;
  late ChatScrollObserver chatObserver;
  final PagingController<int, T> pagingController =
      PagingController(firstPageKey: 0);
  final LayerLink layerLink = LayerLink();
  final ValueNotifier<int> unreadMsgCount = ValueNotifier<int>(0);
  final Map<String, bool> animatedItems = {};
  OverlayEntry? unreadTipOverlay;

  late ChatState<T> state;

  @override
  void didUpdateWidget(covariant MessageListPage<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    state = ChatState<T>(messages: []);
    scrollController.addListener(_scrollControllerListener);
    observerController = ListObserverController(controller: scrollController)
      ..cacheJumpIndexOffset = false;
    chatObserver = ChatScrollObserver(observerController)
      ..fixedPositionOffset = 5
      ..toRebuildScrollViewCallback = () {
        handleEvent(LoadInitialMessages());
      };
    chatObserver.onHandlePositionResultCallback = (result) {
      if (!state.needIncrementUnreadMsgCount) return;
      switch (result.type) {
        case ChatScrollObserverHandlePositionType.keepPosition:
          handleEvent(UpdateUnreadMsgCount(changeCount: result.changeCount));
          break;
        case ChatScrollObserverHandlePositionType.none:
          handleEvent(UpdateUnreadMsgCount(isReset: true));
          break;
      }
    };
    pagingController
        .addPageRequestListener((pageKey) => handleEvent(FetchPage(pageKey)));
    handleEvent(LoadInitialMessages());
    Future.delayed(
        const Duration(seconds: 1), () => handleEvent(AddUnreadTipView()));
  }

  void handleEvent(ChatEvent event) {
    if (event is LoadInitialMessages) {
      _onLoadInitialMessages(event);
    } else if (event is FetchPage) {
      _onFetchPage(event);
    } else if (event is ToggleEditReadOnly) {
      _onToggleEditReadOnly(event);
    } else if (event is AddMessage) {
      _onAddMessage(event);
    } else if (event is UpdateUnreadMsgCount) {
      _onUpdateUnreadMsgCount(event);
    } else if (event is AddUnreadTipView) {
      _onAddUnreadTipView(event);
    }
  }

  Future<void> _onLoadInitialMessages(LoadInitialMessages event) async {
    final initialMessages = widget.createItems;
    setState(() {
      state = state.copyWith(messages: initialMessages);
      pagingController.itemList = initialMessages;
    });
  }

  Future<void> _onFetchPage(FetchPage event) async {
    setState(() => state = state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 2));
    try {
      final newItems = widget.createItems;
      final nextPageKey = event.pageKey + newItems.length;
      pagingController.appendPage(newItems, nextPageKey);
      setState(() => state = state.copyWith(
          messages: pagingController.itemList, isLoading: false));
    } catch (error) {
      pagingController.error = error;
      setState(() =>
          state = state.copyWith(error: error.toString(), isLoading: false));
    }
  }

  void _onToggleEditReadOnly(ToggleEditReadOnly event) {
    setState(() =>
        state = state.copyWith(editViewReadOnly: !state.editViewReadOnly));
  }

  void _onAddMessage(AddMessage event) {
    chatObserver.standby(changeCount: event.messages.length);
    final message = MessageHelper.mockMessages(num: 1).first as T;
    pagingController.itemList?.insert(0, message);
    setState(() => state = state.copyWith(
          needIncrementUnreadMsgCount: true,
        ));
  }

  void _onUpdateUnreadMsgCount(UpdateUnreadMsgCount event) {
    final newCount =
      event.isReset ? 0 : state.unreadMsgCount + event.changeCount;
  unreadMsgCount.value = newCount;
  setState(() => state = state.copyWith(
        unreadMsgCount: newCount,
        needIncrementUnreadMsgCount: false,
      ));
  }

  void _scrollControllerListener() {
    if (scrollController.offset < 50) {
      handleEvent(UpdateUnreadMsgCount(isReset: true));
    }
  }

  void _onAddUnreadTipView(AddUnreadTipView event) {
    setState(() => state = state.copyWith(showUnreadTip: true));
    _addUnreadTipOverlay();
  }

  void _addUnreadTipOverlay() {
    unreadTipOverlay?.remove();
    unreadTipOverlay = OverlayEntry(
      builder: (_) => UnconstrainedBox(
        child: CompositedTransformFollower(
          link: layerLink,
          followerAnchor: Alignment.bottomRight,
          targetAnchor: Alignment.topRight,
          offset: const Offset(-20, 0),
          child: Material(
            type: MaterialType.transparency,
            child: ValueListenableBuilder<int>(
              valueListenable: unreadMsgCount,
              builder: (_, value, __) => UnreadView(
                unreadMsgCount: value,
                onTap: () {
                  scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  handleEvent(UpdateUnreadMsgCount(isReset: true));
                },
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(unreadTipOverlay!);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListViewObserver(
              controller: observerController,
              child: Align(
                alignment: Alignment.topCenter,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        PagedListView<int, T>(
                          pagingController: pagingController,
                          scrollController: scrollController,
                          shrinkWrap: chatObserver.isShrinkWrap,
                          builderDelegate: PagedChildBuilderDelegate<T>(
                            itemBuilder: (context, item, index) {
                              final itemKey = widget.itemKeyExtractor != null
                                  ? widget.itemKeyExtractor!(item)
                                  : index.toString();
                              final isAnimated =
                                  animatedItems[itemKey] ?? false;

                              if (!isAnimated) {
                                animatedItems[itemKey] = true;
                                return SlideTransition(
                                  key: Key(itemKey),
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 1.0),
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                    parent: AnimationController(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      vsync: this,
                                    )..forward(),
                                    curve: Curves.easeInOut,
                                  )),
                                  child: FadeTransition(
                                    opacity: Tween<double>(begin: 0.0, end: 1.0)
                                        .animate(CurvedAnimation(
                                      parent: AnimationController(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        vsync: this,
                                      )..forward(),
                                      curve: Curves.easeInOut,
                                    )),
                                    child: widget.itemBuilder(
                                        context, item, index),
                                  ),
                                );
                              }
                              return widget.itemBuilder(context, item, index);
                            },
                          ),
                          reverse: true,
                          physics: chatObserver.isShrinkWrap
                              ? const NeverScrollableScrollPhysics()
                              : ChatObserverClampingScrollPhysics(
                                  observer: chatObserver),
                          padding: const EdgeInsets.all(15),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          CompositedTransformTarget(link: layerLink, child: Container()),
          Editor(
              textEditingController: textEditingController,
              didTapEmojiButton: () {},
              didTapFileButton: () {},
              didTapSendButton: (_) {
                handleEvent(AddMessage([
                  MessageEntity(
                    messageId: MessageHelper.string(16),
                    messageType: MessageType.text,
                    updateTime: DateTime.now().toIso8601String(),
                    content: textEditingController.text,
                    isOutgoing: Random().nextBool(),
                  )
                ]));
              },
              didTapRemoveAll: () {},
              didDeleteItem: (_) {},
              fileList: [])
        ],
      ),
    );
  }

  late TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    scrollController.dispose();
    pagingController.dispose();
    unreadTipOverlay?.remove();
    super.dispose();
  }
}
