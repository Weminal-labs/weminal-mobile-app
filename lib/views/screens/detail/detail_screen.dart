import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weminal_app/views/components/post_card.dart';
import 'package:weminal_app/views/components/screen_appbar.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: const [
            ScreenAppbar(title: "View Post"),
            PostCard(
              avatar_url: "assets/images/author1.jpg",
              author_name: "John Doe",
              time_posted: "1h ago",
              post_title: "How can I implement zklogin into my mobile app?",
              post_content: "I am trying to implement zklogin into my mobile app but I am having some issues. Can someone help me?",
              post_vote: "${10} votes",
              post_view: "${20} views"
            )
          ],
        ),
      ),
    );
  }
}
