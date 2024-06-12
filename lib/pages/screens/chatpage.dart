import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masenochat/components/chart_bubble.dart';
import 'package:masenochat/services/chart_service/chart_service.dart';

class ChatPage extends StatefulWidget {
  final String recieveruseremail;
  final String recieverUserId;
  final String profile;
  final String uname;
   ChatPage({super.key,
  required this.recieveruseremail,
  required this.recieverUserId,
  required this.profile,
  required this.uname,
  });

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  //initialize
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }
  //scroll to first message
  void scrollToFirstMessage() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
//send message
  void sendMessage() async {

    //ensure message is not empty
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(
          widget.recieverUserId, _messageController.text);
      // clear the textfield
      _messageController.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
             CircleAvatar(
              backgroundImage: NetworkImage(widget.profile), // Replace with your profile photo
            ),
            SizedBox(width: 8),
            Text(widget.uname),
          ],
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'gotofirst') {
                scrollToFirstMessage();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'gotofirst',
                child: Text('Go to First Message'),
              ),
            ],
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 54, 200, 244),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: _buildMessageList(),
          ),
          //user input
          _buildUserInput(),
          SizedBox(height: 25),
        ],
      ),
    );
  }
  //build message list
  Widget _buildMessageList(){
    return StreamBuilder(
        stream: _chatService.getMessages(widget.recieverUserId, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Text('Error${snapshot.error}');
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Text('Loading...');
          }
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        }
    );
  }
// build message item
  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    //align messages depending on the sender if sender is current user or not
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
    ? Alignment.centerRight : Alignment.centerLeft;

    MaterialColor color = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Colors.green : Colors.blueGrey;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
          ?CrossAxisAlignment.end
          :CrossAxisAlignment.start,

          mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ?MainAxisAlignment.end
              :MainAxisAlignment.start,

          children: [
            SizedBox(height: 5),
            ChatBubble(message: data['message'], color: color,),
          ],
        ),
      ),
    );
  }

//build message input
Widget _buildUserInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 9,
            child: TextField(
              controller: _messageController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Message here ...',
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () {
                sendMessage();
              },
              icon: const Icon(Icons.send_sharp),
              color: Colors.blueGrey[400],
            ),
          ),
        ],
      ),
    );
}
}
