import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

        backgroundColor: Colors.blueAccent.withOpacity(0.8),
        onPressed: () {
          NftService.createNft(
            ephemeralKeyPair: LoginProvider.ephemeralKeyPair,
            senderAddress: LoginProvider.userAddressStatic,
            name: '${event.name} Ticket',
            description: '${event.desription}',
            imageUrl: 'data:image/jpeg;base64,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',
          );
          _showAddBottomPopup(context,LoginProvider.userAddressStatic,event.name);
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
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.8),
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
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
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
                            color: Colors.black.withOpacity(0.8),
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

  void _showAddBottomPopup(context, wallet, eventName){
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
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
                    "Owner Wallet",
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
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: wallet));
                        Fluttertoast.showToast(
                            msg: "Copied to clipboard",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "$wallet",
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Event",
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
                      onTap: (){
                        Clipboard.setData(ClipboardData(text: wallet));
                        Fluttertoast.showToast(
                            msg: "Copied to clipboard",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                      readOnly: true,
                      maxLines: 1,
                      decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "$eventName",
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
                        child: Text("Confirm",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      )
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }
}
