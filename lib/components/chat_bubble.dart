import 'package:flutter/material.dart';


class  ChatBubble extends StatefulWidget {
  final String message;
  final bool isCurrentUser;
   const  ChatBubble({super.key, required this.isCurrentUser, required this.message});

  @override
  State< ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State< ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        color: widget.isCurrentUser ? Colors.green: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(12)
      ),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Text(widget.message),
    );
  }
}