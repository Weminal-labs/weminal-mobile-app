import 'package:flutter/material.dart';

class ReplyCard extends StatelessWidget {
  final String avatar_url;
  final String author_name;
  final String time_posted;
  final String reply_content;
  final String like;

  const ReplyCard({
    super.key,
    required this.avatar_url,
    required this.author_name,
    required this.time_posted,
    required this.reply_content,
    required this.like,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black26.withOpacity(0.05),
                offset: Offset(0.0, 6.0),
                blurRadius: 10.0,
                spreadRadius: 0.10)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 60,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage(avatar_url),
                        radius: 22,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                author_name,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: .4),
                              ),
                            ),
                            SizedBox(height: 2.0),
                            Text(
                              time_posted,
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Text(
              reply_content,
              style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontSize: 17,
                  letterSpacing: .2),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.thumb_up,
                        color: Colors.grey.withOpacity(0.5),
                        size: 18,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        like,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
