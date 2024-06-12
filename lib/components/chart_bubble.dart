import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final MaterialColor color;
  const ChatBubble({
    super.key,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width *0.75,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      child: Text(message,
      style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
