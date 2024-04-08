import 'package:flutter/material.dart';

class ScreenAppbar extends StatelessWidget {
  final String title;
  const ScreenAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Row(
        children: <Widget>[
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.black,
              )),
          SizedBox(width: 5.0),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
