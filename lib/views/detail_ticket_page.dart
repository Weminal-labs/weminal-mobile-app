import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:sui/sui.dart';
import 'package:weminal_app/models/NftInfo.dart';
import 'package:weminal_app/views/qr_component.dart';
import 'package:weminal_app/zkSend/builder.dart';

import '../viewmodels/login_provider.dart';

class DetailTicketPage extends StatelessWidget {
  final int index;
  final NftInfo nftInfo;
  const DetailTicketPage({
    Key? key,
    required this.index,
    required this.nftInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final event = context.read<LoginProvider>().events[index];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
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
                        margin: const EdgeInsets.only(top: 35, left: 10),
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                        child: const Row(
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
                                  fontFamily:
                                      'assets/fonts/Montserrat-Regular.ttf',
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
                              style: const TextStyle(
                                fontSize: 26,
                                fontFamily:
                                    'assets/fonts/Montserrat-ExtraBold.ttf',
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
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            event.startAt,
                            style: const TextStyle(
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
                            event.location.name,
                            style: const TextStyle(
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          event.desription,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontFamily: 'assets/fonts/Montserrat-Regular.ttf',
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 5),
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
                          const SizedBox(width: 10),
                          Text(
                            event.host.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily:
                                  'assets/fonts/Montserrat-Extra-Bold.ttf',
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(36),
                      )),
                      child: const Text(
                        'Join Event',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () async {
                        print(
                            'nftInfo.suiObjectRef.digest: ${nftInfo.suiObjectRef.digest}');
                        print(
                            'nftInfo.suiObjectRef.objectId: ${nftInfo.suiObjectRef.objectId}');
                        print(
                            'nftInfo.suiObjectRef.version: ${nftInfo.suiObjectRef.version}');
                        print(
                            'nftInfo.suiObjectRef.objectType: ${nftInfo.objectType}');

                        String url = await ZkSendLinkBuilder.createLinkObject(
                            ephemeralKeyPair: LoginProvider.ephemeralKeyPair,
                            senderAddress: LoginProvider.userAddressStatic,
                            suiObjectRef: SuiObjectRef(
                                nftInfo.suiObjectRef.digest,
                                nftInfo.suiObjectRef.objectId,
                                nftInfo.suiObjectRef.version),
                            objectType: nftInfo.objectType);
                        print('detail ticket url: $url');
                        _showAddBottomPopup(context, url);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: const Text(
                        'Send Ticket',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _showAddBottomPopup(context, qrLink) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: QrComponent(
            qrLink: qrLink,
          ),
        );
      },
    );
  }

}
