import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masenochat/model/message.dart';
import 'package:masenochat/model/tweet.dart';

class ChatService extends ChangeNotifier{
  // get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // send Tweet
  Future<void> sendTweet(String text, String profile, String uname)async{
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();
    String timestampnow = DateTime.now().microsecondsSinceEpoch.toString();
    // create new tweet
    Tweet newTweet = Tweet(id: timestampnow,profile: profile, text: text, userId: currentUserId, uname: uname, timestamp: timestamp, comments: [], likes: [], retweets: 0);

    await _firestore
        .collection('Tweets').doc(timestampnow).set(newTweet.toMap());
  }
  // Send Message
  Future<void> sendMessage(String receiverId, String message) async {
    //get current user info
  final String currentUserId = _firebaseAuth.currentUser!.uid;
  final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
  final Timestamp timestamp = Timestamp.now();
    //create a new message
  Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp);
    //create a unique chatroom id
    List<String> ids = [currentUserId, receiverId];
    //ensure chat room id is same for any pair of ids
    ids.sort();
    //create chat room id by combining the two ids to a string
    String chatroomId = ids.join("_");

    //add new message to database
    await _firestore
  .collection('chatrooms')
  .doc(chatroomId)
  .collection('messages')
  .add(newMessage.toMap());
  }
  //Recieve Message
Stream<QuerySnapshot> getMessages(String userId, String otherUserId){
    // construct chatroom for the two users
  List<String> ids = [userId, otherUserId];
  ids.sort();
  String chatroomId = ids.join("_");

  return _firestore
      .collection('chatrooms')
      .doc(chatroomId)
      .collection('messages')
      .orderBy('timestamp',descending: false)
      .snapshots();
}

}