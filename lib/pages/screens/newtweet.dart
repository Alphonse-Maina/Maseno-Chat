import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/listtile.dart';
import '../../services/chart_service/chart_service.dart';

class TweetComposer extends StatefulWidget {
  @override
  _TweetComposerState createState() => _TweetComposerState();
}

class _TweetComposerState extends State<TweetComposer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();
  final TextEditingController _tweetController = TextEditingController();
  String _profilePictureUrl = '';
  String _username = '';

  @override
  void initState() {
    super.initState();
    _retrieveProfilePictureUrl();
  }

  Future<void> _retrieveProfilePictureUrl() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final snapshot = await _firestore.collection('users').doc(currentUser.uid).get();
      final userData = snapshot.data();
      setState(() {
        _profilePictureUrl = userData?['profile'];
        _username = userData?['uname'];

      });
    }
  }

  void sendTweet(tweet) async {

    //ensure message is not empty
    if(tweet.isNotEmpty){
      await _chatService.sendTweet(tweet, _profilePictureUrl, _username );
      // clear the textfield
      _tweetController.clear();
    }
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Compose Tweet'),
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 54, 200, 244),
      actions: [
        TextButton(
          onPressed: () {
            // Post tweet functionality
            final tweet = _tweetController.text;
            print('Tweet: $tweet');
            _tweetController.clear(); // Clear tweet text after sending
          },
          child: Text(
            'Tweet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TextField(
              controller: _tweetController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "What's happening?",
                border: InputBorder.none, // Remove border
              ),
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // Post tweet functionality
              final tweet = _tweetController.text;
              sendTweet(tweet);
              _tweetController.clear(); // Clear tweet text after sending
            },
            child: Text('Send'),
          ),
          SizedBox(height: 8),
          Expanded(
            child: _buildList(),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildList(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Tweets').snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return const Text('Error');
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text('Loading...');
        }
        return ListView(
          children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(context, doc)).toList(),
        );
      },
    );
  }
//build individual user list tile
  Widget _buildUserListItem(BuildContext context, DocumentSnapshot document){

    Map<String, dynamic> data = document.data()! as Map<String , dynamic>;
    if(_auth.currentUser!.uid == data['userId']){
      return Tweettile(uname: data['uname'], profile: data['profile'],userId: data['userId'],tweetId: data['id'], comments: data['comments'], tweet: data['text'], likes: data['likes'], retweets: data['retweets'], timestamp: data['timestamp'],);
    }else{
      //return empty container
      return Container();
    }
  }

@override
void dispose() {
  _tweetController.dispose();
  super.dispose();
}
}