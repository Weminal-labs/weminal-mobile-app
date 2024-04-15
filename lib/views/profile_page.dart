import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:weminal_app/viewmodels/login_provider.dart';

import '../states/login_state.dart';
import '../widget/stack_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userAddress = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 800,
        child: Stack(
          children: [
            Image.asset('assets/images/background_profile.png'),
            Column(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage('assets/images/avt1.png'))),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Image.asset(
                        'assets/images/switch.png',
                        height: 40,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Trần Hữu Tài',
                  style: TextStyle(
                      color: Color(0xff5669FF),
                      fontWeight: FontWeight.w800,
                      fontSize: 36),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 65,
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: const Color(0xff5669FF).withOpacity(0.31),
                      borderRadius: BorderRadius.circular(12)),
                  child: Consumer<LoginProvider>(
                    builder: (BuildContext context, value, Widget? child) {
                      switch (value.state) {
                        case LoginState.loaded:
                          userAddress =
                              context.read<LoginProvider>().userAddress;
                          String lead = userAddress.substring(2, 6);
                          String tail =
                              userAddress.substring(userAddress.length - 4);
                          context.read<LoginProvider>().getNfts(userAddress);
                          context.read<LoginProvider>().createNft();
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'WalletID: 0X-$lead-XXXX-$tail',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const ImageIcon(
                                    AssetImage('assets/images/icon_copy.png'),
                                    color: Color(0xff5669FF),
                                  ))
                            ],
                          );
                        default:
                          return LoadingAnimationWidget.prograssiveDots(
                              color: Colors.white, size: 150);
                      }
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 16),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 20),
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
                          itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) =>
                              _buildCarouseItem(),
                          options: CarouselOptions(
                            height: 340,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.8,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.3,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCarouseItem() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0xffBDBDBDFF),
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
                        color: Color(0xff2B2849), fontWeight: FontWeight.w400),
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
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: const ImageIcon(
                AssetImage("assets/images/icon_save.png"),
                color: Color(0xffF0635A),
              )),
        ),
      ],
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
}
