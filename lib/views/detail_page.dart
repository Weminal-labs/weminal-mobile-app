import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:weminal_app/services/nft_service.dart';
import 'package:weminal_app/zkSend/builder.dart';

import '../viewmodels/login_provider.dart';

class DetailPage extends StatelessWidget {
  final int index;
  const DetailPage({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final event = context.read<LoginProvider>().events[index];
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NftService.createNft(
              ephemeralKeyPair: ZkSendLinkBuilder.keypair,
              senderAddress: LoginProvider.userAddressStatic,
              arg1: 'atg1',
              arg2: 'arg2',
              arg3: 'arg3',
              packageId:
                  '0xbfec71e0f811e27d3393b0470941fe3da85df8c7df8497d5538cc758f90cb2ef',
              userAddress: LoginProvider.userAddressStatic);
          // _showAddBottomPopup(context);
        },
        child: Icon(
          Icons.attach_money,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(event.coverUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 35, left: 10),
                    width: 100,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text("Back",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'assets/fonts/Montserrat-Regular.ttf',
                            )),
                      ],
                    ),
                  ),
                ),
              ],
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: Text(
                          event.name,
                          style: TextStyle(
                            fontSize: 26,
                            fontFamily: 'assets/fonts/Montserrat-ExtraBold.ttf',
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                      ),
                      SizedBox(width: 12),
                      Text(
                        event.startAt,
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
                      Icon(
                        Icons.location_on_rounded,
                        color: Colors.black,
                      ),
                      SizedBox(width: 12),
                      Text(
                        event.location.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'assets/fonts/Montserrat-Regular.ttf',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "About",
                    style: TextStyle(
                      color: Color(0xff5669FF),
                      fontSize: 24,
                      fontFamily: 'assets/fonts/Montserrat-ExtraBold.ttf',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      event.desription,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: 'assets/fonts/Montserrat-Regular.ttf',
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 5),
                  const Text(
                    "Created by",
                    style: TextStyle(
                      color: Color(0xff5669FF),
                      fontSize: 24,
                      fontFamily: 'assets/fonts/Montserrat-ExtraBold.ttf',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: event.host.avatarUrl != null
                            ? NetworkImage(event.host.avatarUrl)
                            : const AssetImage('assets/images/avt1.png')
                                as ImageProvider,
                      ),
                      SizedBox(width: 10),
                      Text(
                        event.host.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'assets/fonts/Montserrat-Extra-Bold.ttf',
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBottomPopup(context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Your Ticket",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Divider(
                      thickness: 1.2,
                      color: Colors.grey.shade200,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Name",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6)),
                      child: TextField(
                        decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Price",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6)),
                      child: TextField(
                        decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6))),
                          child: Text("Buy Ticket",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        )
                      ],
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }
}
