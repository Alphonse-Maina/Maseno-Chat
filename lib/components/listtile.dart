import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../pages/screens/chatpage.dart';
import '../pages/screens/picture.dart';

class UserTile extends StatelessWidget {
  final String email;
  final String uid;
  final String profile;
  final String uname;

  const UserTile({super.key,
    required this.email,
    required this.uid,
    required this.profile,
    required this.uname,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Stack(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            leading: GestureDetector(
              onTap: () {
                // Navigate to another page when the CircleAvatar is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Pic(uname: uname,profile: profile), // Replace AnotherPage with your desired page
                  ),
                );
              },
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(profile), // Profile image
              ),
            ),
            title: Text(uname),
            //subtitle: Text(message.isNotEmpty ? message.last : 'No messages'),// User's email
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    recieveruseremail: email,
                    recieverUserId: uid,
                    profile: profile,
                    uname: uname,
                  ),
                ),
              );
            },
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text( 'time', // Replace with actual timestamp
                style: TextStyle(fontSize: 12.0, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),

    );
  }
}

class Tweettile extends StatefulWidget {
  final String uname;
  final String profile;
  final String userId;
  final String tweetId;
  final List comments;
  final String tweet;
  final List likes;
  final int retweets;
  final Timestamp timestamp;

   const Tweettile({super.key,
    required this.uname,
    required this.profile,
     required this.userId,
     required this.tweetId,
    required this.comments,
    required this.tweet,
    required this.likes,
    required this.retweets,
    required this.timestamp,
  });

  @override
  State<Tweettile> createState() => _TweettileState();
}

class _TweettileState extends State<Tweettile> {
  Future<String> getTimeDifference(Timestamp timestamp) async {
    final DateTime parsedTime = timestamp.toDate();
    final Duration difference = DateTime.now().difference(parsedTime);
    final int minutes = difference.inMinutes.abs();
    final int hours = difference.inHours.abs();
    final int days = difference.inDays.abs();

    if (days > 0) {
      return '$days days ago';
    } else if (hours > 0) {
      return '$hours hours ago';
    } else {
      return '$minutes minutes ago';
    }
  }

  String timeDifference = '';

  @override
  void initState() {
    super.initState();
    calculateTimeDifference();
  }

  void calculateTimeDifference() {
    getTimeDifference(widget.timestamp).then((value) {
      setState(() {
        timeDifference = value;
      });
    });
  }
  void updateLikesList(String tweetId, String userId) async {
    try {
      // Reference to the document
      DocumentReference tweetRef = FirebaseFirestore.instance.collection('Tweets').doc(tweetId);

      // Get the current document snapshot
      DocumentSnapshot tweetSnapshot = await tweetRef.get();

      if (tweetSnapshot.exists) {
        // Get the current likes list or initialize it as an empty list
        Map<String, dynamic>? data = tweetSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          List<dynamic> likesList = data['likes'] ?? [];

          // Check if the user has already liked the tweet
          if (!likesList.contains(userId)) {
            // Add the user to the likes list
            likesList.add(userId);

            // Update the likes list in Firestore
            await tweetRef.update({'likes': likesList});
            print('Likes list updated successfully.');
          } else {
            likesList.remove(userId);
            await tweetRef.update({'likes': likesList});
            print('User already liked this tweet.');
          }
        } else {
          print('No data found in the document.');
        }
      } else {
        print('Tweet document does not exist for ID: $tweetId');
      }
    } catch (error) {
      print('Error updating likes list: $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.7),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Stack(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            leading: GestureDetector(
              onTap: () {
                // Navigate to another page when the CircleAvatar is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Pic(uname: widget.uname,profile: widget.profile), // Replace AnotherPage with your desired page
                  ),
                );
              },
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(widget.profile), // Profile image
              ),
            ),
            title: Text(widget.uname, style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Column(
              children: [
                SizedBox(height: 5),
                Row(
                  children:[
                    Text(widget.tweet),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        print("favorite clicked");
                        updateLikesList(widget.tweetId, widget.userId);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.favorite_border),
                          Text(widget.likes.length.toString()),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        // Add your comment action here
                      },
                      child: Row(
                        children: [
                          Icon(Icons.chat_bubble_outline),
                          Text(widget.comments.length.toString()),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        // Add your retweet action here
                      },
                      child: Row(
                        children: [
                          Icon(Icons.repeat),
                          Text(widget.retweets.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // onTap: () {
            //   print("clicked");
            // },
          ),
           Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text( timeDifference, // Replace with actual timestamp
                style: TextStyle(fontSize: 12.0, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),

    );
  }
}
