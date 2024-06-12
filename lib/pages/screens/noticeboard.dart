import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masenochat/components/listtile.dart';
import 'package:masenochat/pages/screens/newtweet.dart';

//import '../../model/tweet.dart';

class TwitterHomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void newTweet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TweetComposer()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          newTweet(context);
          // Add your new tweet functionality here
        },
        child: Icon(Icons.add),
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
    if(_auth.currentUser!.uid != data['userId']){
      return Tweettile(uname: data['uname'], profile: data['profile'],userId: data['userId'],tweetId: data['id'], comments: data['comments'], tweet: data['text'], likes: data['likes'], retweets: data['retweets'], timestamp: data['timestamp'],);
    }else{
      //return empty container
      return Container();
    }
  }
}



