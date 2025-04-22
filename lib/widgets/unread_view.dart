import 'package:flutter/material.dart';

class UnreadView extends StatelessWidget {
  UnreadView({
    Key? key,
    required this.unreadMsgCount,
    this.onTap,
  }) : super(key: key);
  final int unreadMsgCount;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (unreadMsgCount == 0) return const SizedBox.shrink();
    Widget resultWidget = Stack(
      children: [
        const Icon(
          Icons.mode_comment,
          size: 50,
          color: Colors.red,
        ),
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 50,
          child: Center(
            child: Text(
              '$unreadMsgCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
    resultWidget = GestureDetector(
      onTap: onTap,
      child: resultWidget,
    );
    return resultWidget;
  }
}
