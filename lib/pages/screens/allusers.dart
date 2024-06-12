import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/listtile.dart';
class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('All Users'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 54, 200, 244),

          ),
      body: Container(
    // create user list
    child: _buildList()
    )
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

