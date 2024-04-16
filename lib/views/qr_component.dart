import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrComponent extends StatelessWidget {
  final String qrLink;

  QrComponent({required this.qrLink});

  @override
  Widget build(BuildContext context) {
    final qrCode = QrCode(
      8,
      QrErrorCorrectLevel.H,
    )..addData(qrLink);

    QrImage qrImage = QrImage(
        qrCode
    );
    return Container(
        height: 800,
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
                "zkSend link",
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
                    Clipboard.setData(ClipboardData(text: qrLink));
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
                      hintText: "$qrLink",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: PrettyQrView(
                    qrImage: qrImage,
                    decoration: const PrettyQrDecoration(
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ));
  }
}