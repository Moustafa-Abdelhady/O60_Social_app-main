import 'package:flutter/material.dart';
import 'package:o_social_app/constants/colors/app_colors.dart';
import 'package:o_social_app/models/message.dart';



class ChatBuble extends StatelessWidget {
  const ChatBuble({
    super.key,
    required this.message,
    required this.id,
  });

  final Message message;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(left: 18, top: 25, bottom: 25, right: 18),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        // transform:Matrix4.translationValues(5, 2, 0),

        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomRight: Radius.circular(32),
            bottomLeft: Radius.circular(5),
          ),
        ),
        child: Column(
          children: [
            Text(
              '${id}',
              style: TextStyle(
                color: Colors.white70,
                fontSize:12,
              ),
            ),
            SizedBox(height:5),
            Text(
              '${message.message}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class otherChatBuble extends StatelessWidget {
  const otherChatBuble({
    super.key,
    required this.message,
     required this.id,
  });

  final Message message;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.only(left: 18, top: 25, bottom: 25, right: 18),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        // transform:Matrix4.translationValues(5, 2, 0),

        decoration: BoxDecoration(
          color: Color(0xff006D84),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomRight: Radius.circular(5),
            bottomLeft: Radius.circular(32),
          ),
        ),
        child: Column(
          children: [
             Text(
              '${id}',
              style: TextStyle(
                color: Colors.white70,
                fontSize:12,
              ),
            ),
            SizedBox(height:5),
            Text(
              '${message.message}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
