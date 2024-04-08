import 'package:flutter/material.dart';

import '../../components/app_bar/screen_appbar.dart';
import '../../components/post/post_card.dart';
import '../../components/post/reply_card.dart';
import '../../components/title/title_component.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30.0),
                  ScreenAppbar(title: "View Post"),
                  PostCard(
                      avatar_url: "assets/images/author1.jpg",
                      author_name: "John Doe",
                      time_posted: "1h ago",
                      post_title:
                          "How can I implement zklogin into my mobile app?",
                      post_content:
                          "I am trying to implement zklogin into my mobile app but I am having some issues. Can someone help me?",
                      post_vote: "${10} votes",
                      post_view: "${20} views"),
                  SizedBox(height: 10.0),
                  TitleComponent(no_replies: 80),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (_, __) => SizedBox(height: 15.0),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return ReplyCard(
                            avatar_url: "assets/images/author1.jpg",
                            author_name: "John Doe",
                            time_posted: "1h ago",
                            reply_content:
                                "I am trying to implement zklogin into my mobile app but I am having some issues. Can someone help me?",
                            like: "${123} ",
                          );
                        }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    elevation: 20.0,
                    shadowColor: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: TextField(
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            prefixIcon: InkWell(
                              onTap: () {},
                              child: Icon(
                                Icons.attach_file,
                                color: Colors.grey,
                              ),
                            ),
                            suffixIcon: InkWell(
                              onTap: () {},
                              child: Icon(
                                Icons.send,
                                color: Colors.lightBlue,
                              ),
                            ),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            )),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
