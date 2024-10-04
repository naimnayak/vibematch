import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice/components/chat_bubble.dart';
import 'package:practice/services/chat/chat_services.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //text controller
  final TextEditingController _messageController = TextEditingController();

  //chat services

  final ChatServices _chatServices = ChatServices();

  // send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      String message = _messageController.text.trim();
      await _chatServices.sendMessage(widget.receiverID, message);
      _messageController.clear();
      // Log sent message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          // display all the messages
          Expanded(child: _buildMessageList()),
          //user input
          _buildUserInput()
        ],
      ),
    );
  }

  // build message list
  // Build message list
  Widget _buildMessageList() {
    String senderId = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<QuerySnapshot>(
        stream: _chatServices.getMessages(senderId, widget.receiverID),
        builder: (context, snapshot) {
          // Handle errors
          if (snapshot.hasError) {
            return const Text('Error loading messages');
          }

          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check if there are documents in the snapshot
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('No messages yet');
          }

          // If data is available, map over the documents
          return ListView(
            children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
          );
        });
  }

  //build message
  // Build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser = data["senderID"] == FirebaseAuth.instance.currentUser!.uid;

    // align message to the right if sender is current user or on the left
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [
          ChatBubble(isCurrentUser: isCurrentUser, message: data["message"]),
        ],
      )); // Access the 'message' key
    //subtitle: Text(data['senderEmail'] ?? 'Unknown sender'), // Optionally show sender email
  }

  //build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Row(
        children: [
          //textfield should take most of the space
      
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: _messageController,
              obscureText: false,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  
                ),
                filled: true,
                hintText: "Type a message",
              ),
            ),
          )),
          //sendbutton
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(right: 25),
            child: IconButton(onPressed: sendMessage, icon: Icon(Icons.arrow_upward,color: Colors.white,)))
        ],
      ),
    );
  }
}
