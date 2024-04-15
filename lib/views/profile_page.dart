import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sui/http/http.dart' as http;
import 'package:sui/types/objects.dart';
import 'package:weminal_app/models/NftInfo.dart';
import 'package:weminal_app/services/nft_service.dart';
import 'package:weminal_app/utilities/fake_data.dart';
import 'package:weminal_app/utilities/router_manager.dart';
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
            Container(
              width: double.maxFinite,
              child: Image.asset(
                'assets/images/bg_app.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: EdgeInsets.only(top: 50),
                        width: 150,
                        height: 150,
                        decoration: const BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Color(0xffbdbdbd),
                                blurRadius: 22,
                              ),
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image:
                                    AssetImage('assets/images/lhp_avt.jpg'))),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Image.asset(
                        'assets/images/switch.png',
                        height: 40,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Lê Huỳnh Phát',
                  style: TextStyle(
                      color: Color(0xff5669FF),
                      fontWeight: FontWeight.w800,
                      fontSize: 32),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06),
                  height: 65,
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16)),
                  child: Consumer<LoginProvider>(
                    builder: (BuildContext context, value, Widget? child) {
                      switch (value.state) {
                        case LoginState.loaded:
                          userAddress =
                              context.read<LoginProvider>().userAddress;
                          String lead = userAddress.substring(2, 6);
                          String tail =
                              userAddress.substring(userAddress.length - 4);
                          // context.read<LoginProvider>().createNft();
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
                                  onPressed: () async {
                                    await Clipboard.setData(
                                        ClipboardData(text: userAddress));
                                    Fluttertoast.showToast(
                                        msg: "Copied to clipboard",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.grey,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  },
                                  icon: const ImageIcon(
                                    AssetImage('assets/images/icon_copy.png'),
                                    color: Colors.lightBlue,
                                  ))
                            ],
                          );
                        default:
                          return LoadingAnimationWidget.prograssiveDots(
                              color: Colors.white, size: 50);
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
                            'My Tickets',
                            style: TextStyle(
                                color: Color(0xff5669FF),
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: Consumer<LoginProvider>(
                            builder: (context, value, child) {
                              Widget myWidget = CarouselSlider.builder(
                                itemCount: 1,
                                itemBuilder: (BuildContext context,
                                    int itemIndex, int pageViewIndex) {
                                  return _buildCarouseItemShimmer();
                                },
                                options: _getCarouseOption(),
                              );
                              switch (value.state) {
                                case LoginState.loaded:
                                  return SizedBox(
                                    child: FutureBuilder(
                                      future: NftService.getNfts(userAddress),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return CarouselSlider.builder(
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (BuildContext context,
                                                int itemIndex,
                                                int pageViewIndex) {
                                              return _buildCarouseItem(
                                                  snapshot.data![itemIndex]);
                                            },
                                            options: _getCarouseOption(),
                                          );
                                        } else {
                                          return myWidget;
                                        }
                                      },
                                    ),
                                  );
                                default:
                                  return myWidget;
                              }
                            },
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

  Widget _buildCarouseItemShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[200]!,
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
          Container(
            width: double.maxFinite,
            color: Colors.grey.withOpacity(0.5),
            height: 18,
          ),
          const SizedBox(
            height: 8,
          ),
          buildStackedImages(),
          const SizedBox(
            height: 4,
          ),
          Container(
            width: 200,
            color: Colors.grey.withOpacity(0.5),
            height: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildCarouseItem(SuiObjectResponse object) {
    String? url = object.data?.content?.fields['url'];
    print('nftUrl: $url');
    return GestureDetector(
      onTap: () {
        var index = FakeData.findIndexById(
            object.data?.content?.fields['event_id'] ?? '');
        print("index: $index");
        Navigator.pushNamed(context, Routes.detailTicketPage, arguments: [
          index == -1 ? 0 : index,
          NftInfo(
              suiObjectRef: SuiObjectRef(object.data!.digest,
                  object.data!.objectId, object.data!.version),
              objectType: object.data!.type!)
        ]);
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0xffbdbdbdff),
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
                    child: _handleUrl(url),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  object.data?.content?.fields['name'] ?? '',
                  style: const TextStyle(
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
            left: 280,
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

  CarouselOptions _getCarouseOption() {
    return CarouselOptions(
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
    );
  }

  dynamic _handleUrl(String? url) {
    print('my ticket url: $url');
    if (url == null) {
      return Image.asset('assets/images/event_background.png');
    }

    late Uint8List decodeUrl;
    if (url.contains('data:image/jpeg;base64,')) {
      decodeUrl = base64Decode(url.replaceAll('data:image/jpeg;base64,', ''));
      return Image.memory(decodeUrl);
    }
    if (url.contains('png') || url.contains('jpg')) {
      return Image.network(url);
    }
    return Image.asset('assets/images/event_background.png');
  }
}
