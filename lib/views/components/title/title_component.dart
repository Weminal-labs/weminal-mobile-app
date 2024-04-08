import 'package:flutter/material.dart';

class TitleComponent extends StatelessWidget {
  final int no_replies;
  const TitleComponent({
    super.key,
    required this.no_replies,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, top: 20.0, bottom: 10.0),
      child: Text(
        "Replies (${no_replies})",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
