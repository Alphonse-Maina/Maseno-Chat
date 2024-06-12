import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  final String id;
  final String profile;
  final String text;
  final String userId;
  final String uname;
  final Timestamp timestamp;
  List<String> comments;
  List<String> likes;
  int retweets;

  Tweet({
    required this.id,
    required this.profile,
    required this.text,
    required this.userId,
    required this.uname,
    required this.timestamp,
    required this.comments,
    required this.likes,
    required this.retweets,
  });

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'profile': profile,
      'text': text,
      'userId': userId,
      'uname': uname,
      'timestamp': timestamp,
      'comments': comments,
      'likes': likes,
      'retweets': retweets,
    };
  }

  factory Tweet.fromMap(Map<String, dynamic> map, String id) {
    return Tweet(
      id: id,
      text: map['text'],
      userId: map['userId'],
      uname: map['uname'],
      timestamp: map['timestamp'],
      comments: List<String>.from(map['comments'] ?? []),
      likes: List<String>.from(map['likes'] ?? []),
      retweets: map['retweets'] ?? 0,
      profile: map['profile'],
    );
  }
}
