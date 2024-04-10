import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:weminal_app/utilities/router_manager.dart';
import 'package:weminal_app/models/event_model.dart';

import '../widget/stack_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> json = [
    {
      "id": "evt-AipW3EfmGB81vDC",
      "name": "Introduction to Sui and Move",
      "cover_url":
          "https://images.lumacdn.com/event-covers/uk/29286153-12c1-4d8b-9c36-b838840115bd",
      "created_at": "2024-03-12T01:41:30.679Z",
      "start_at": "2024-03-21T12:00:00.000Z",
      "end_at": "2024-03-21T13:00:00.000Z",
      "location": {"name": "Ho Chi Minh city"},
      "timezone": "Europe/London",
      "ticket": {
        "price": 0,
        "is_sold_out": false,
        "spots_remaining": 0,
        "is_near_capacity": false,
        "ticket_currency": "usd"
      },
      "host": {
        "owner": "usr-eov0TQqLezYv8WO",
        "name": "Sui Foundation",
        "avatar_url":
            "https://images.lumacdn.com/avatars/79/26309b69-c772-47bd-8659-f4b2e9ca073e",
        "bio_short":
            "The Sui Foundation supports the advancement and adoption of the Sui blockchain ecosystem.",
        "website": "https://sui.io/",
        "instagram_handle": "",
        "linkedin_handle": "/company/sui-foundation",
        "tiktok_handle": "",
        "twitter_handle": "suinetwork",
        "youtube_handle": "Sui-Network",
        "timezone": "Asia/Manila"
      }
    }
    // 13 more events
  ];

  @override
  Widget build(BuildContext context) {
    for (Map<String, dynamic> m in json) {
      print(m);
      Event e = Event.fromJson(m);
      print(e);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 34.0, top: 20),
                child: Text(
                  'Event latest',
                  style: TextStyle(
                      color: Color(0xff5669FF),
                      fontSize: 20,
                      fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              CarouselSlider.builder(
                itemCount: 15,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) =>
                        _buildCarouseItem(context),
                options: CarouselOptions(
                  height: 340,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 34.0, top: 20),
                child: Text(
                  'Event joined',
                  style: TextStyle(
                      color: Color(0xff5669FF),
                      fontSize: 20,
                      fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              CarouselSlider.builder(
                itemCount: 15,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) =>
                        _buildCarouseItem(context),
                options: CarouselOptions(
                  height: 340,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              const SizedBox(
                height: 120,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStackedImages({
    TextDirection direction = TextDirection.ltr,
  }) {
    const double size = 34;
    const double xShift = 12;
    final urlImages = [
      'assets/images/avt1.png',
      'assets/images/avt2.png',
      'assets/images/avt3.png',
    ];

    final items = urlImages.map((urlImage) => buildImage(urlImage)).toList();

    return StackedWidgets(
      direction: direction,
      items: items,
      size: size,
      xShift: xShift,
    );
  }

  Widget buildImage(String urlImage) {
    const double borderSize = 5;

    return ClipOval(
      child: Container(
        padding: const EdgeInsets.all(borderSize),
        color: Colors.white,
        child: ClipOval(
          child: Image.asset(
            urlImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildCarouseItem(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.detailPage);
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0xffbdbdbd),
                blurRadius: 22,
              ),
            ], color: Colors.white, borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage("assets/images/event_background.png"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'Internation Band Mu...',
                  style: TextStyle(
                      fontFamily: "Oswald",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 8,
                ),
                buildStackedImages(),
                const Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Color(0xff716E90),
                    ),
                    Text(
                      '60 people attended',
                      style: TextStyle(
                          color: Color(0xff2B2849),
                          fontWeight: FontWeight.w400),
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: 22,
            left: 24,
            child: Container(
              height: 60,
              width: 65,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '10',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xffF0635A),
                    ),
                  ),
                  Text(
                    'JUNE',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xffF0635A),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 25,
            left: 260,
            child: Container(
                height: 43,
                width: 40,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: const ImageIcon(
                  AssetImage("assets/images/icon_save.png"),
                  color: Color(0xffF0635A),
                )),
          ),
        ],
      ),
    );
  }
}
