import 'package:flutter/material.dart';
import 'package:list_view/message_list/message_list.dart';
import 'package:ziichat_ui_v2/utils/constants/enum.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MessageList(
        title: 'title',
        subTitle: 'subTitle',
        state: ChannelTitleState.online,
        imageUrl: 'https://picsum.photos/id/200/64/64',
        fileList: [],
        messages: [],
        textEditingController: TextEditingController());
  }
}
