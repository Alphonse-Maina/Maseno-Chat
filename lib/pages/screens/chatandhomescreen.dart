import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masenochat/components/listtile.dart';

import 'allusers.dart';


class ChatsAndHomeScreen extends StatelessWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  void messagenew(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AllUsers()),
    );
  }
  @override
  Widget build(BuildContext context) {
    // Your implementation for the Chats and Home screen
    return Scaffold(
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          messagenew(context);
        },
        backgroundColor:  const Color.fromARGB(255, 54, 200, 244),
        child: Icon(Icons.comment, color: Colors.white),
      ),
    );
  }
  Widget _buildList(){
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
    if(_auth.currentUser!.email != data['email']){
      return UserTile(email: data['email'], uid: data['uid'],profile: data['profile'],uname: data['uname']);
    }else{
      //return empty container
      return Container();
    }
  }
}
