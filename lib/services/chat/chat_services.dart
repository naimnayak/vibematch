import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practice/models/message.dart';

class ChatServices {
  //get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // going through individual user

        final User = doc.data();

        //return user
        return User;
      }).toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiverID, message) async {
    //get current user info
    final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    final String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create new message
    Message newMessage = Message(message: message, receiverID: receiverID, senderEmail: currentUserEmail, senderID: currentUserID, timestamp: timestamp);

    //construct chatroom id or two users(ensuring uniqueness)
    List<String> ids = [
      currentUserID,
      receiverID
    ];
    ids.sort(); // ensures chatroom id is same for 2 people
    String chatRoomID = ids.join('_');
    //add new message to the database
    await _firestore.collection('chatrooms').doc(chatRoomID).collection('messages').add(newMessage.toMap());
  }

  // get messages
Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
  // construct a chatroom id for two users
  List<String> ids = [userID, otherUserID];
  ids.sort();
  String chatRoomId = ids.join('_');

  // Ensure you're using the correct collection name
  return _firestore
      .collection("chatrooms") // Check if this matches your Firestore collection
      .doc(chatRoomId)
      .collection("messages")
      .orderBy("timestamp", descending: false)
      .snapshots();
}

}
