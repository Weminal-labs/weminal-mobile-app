import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/detail_event_img.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Micro Front-end - new tech",
                          style: TextStyle(
                            fontSize: 26,
                            fontFamily: 'assets/fonts/Montserrat-ExtraBold.ttf',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "12/12/2021",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontFamily: 'assets/fonts/Montserrat-Regular.ttf',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Soekarno Hatta Sport Center",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontFamily: 'assets/fonts/Montserrat-Regular.ttf',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "About",
                      style: TextStyle(
                        color: Color(0xff5669FF),
                        fontSize: 24,
                        fontFamily: 'assets/fonts/Montserrat-ExtraBold.ttf',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        textAlign: TextAlign.justify,
                        "Micro Front-end is a new technology that is being used by many companies. It is a new way to build web applications that are more scalable and easier to maintain. This event will introduce you to the basics of Micro Front-end and how you can use it to build your own web applications.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'assets/fonts/Montserrat-Regular.ttf',
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 20,
                      ),
                    ),
                    Text(
                      "Created by",
                      style: TextStyle(
                        color: Color(0xff5669FF),
                        fontSize: 24,
                        fontFamily: 'assets/fonts/Montserrat-ExtraBold.ttf',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage:
                              AssetImage('assets/images/avatar.png'),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "John Doe",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily:
                                'assets/fonts/Montserrat-Extra-Bold.ttf',
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Qr Code",
                      style: TextStyle(
                        color: Color(0xff5669FF),
                        fontSize: 24,
                        fontFamily: 'assets/fonts/Montserrat-ExtraBold.ttf',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          child: PrettyQrView.data(
                            data: 'https://www.facebook.com/wrxhard/',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
