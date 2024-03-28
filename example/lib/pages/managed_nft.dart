import 'package:another_flushbar/flushbar.dart';
import 'package:example/contracts/contract_bytes.dart';
import 'package:example/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:sui/signers/txn_data_serializers/txn_data_serializer.dart';
import 'package:sui/sui_client.dart';
import 'package:sui/types/objects.dart';
import 'package:sui/types/transactions.dart';
import 'package:sui/sui.dart';

class ManagedNFT extends StatefulWidget {
  const ManagedNFT({required this.client, Key? key}) : super(key: key);

  final SuiClient client;

  @override
  State<StatefulWidget> createState() => _ManagedNFTState();
}

class _ManagedNFTState extends State<ManagedNFT> {
  SuiAccount? account;

  @override
  void initState() {
    getSuiAccount().then((value) {
      setState(() {
        account = value;
      });
    });
    super.initState();
  }

  TextEditingController nameTextController = TextEditingController();
  TextEditingController descTextController = TextEditingController();
  TextEditingController urlTextController = TextEditingController();
  TextEditingController burnTextController = TextEditingController();

  String? packageId =
      '0xb4b091bfe765ef63a07771c5720a7248ea14f778ac2b597009b94179fcde764a';
  String? objectId;
  String? transactionModule = 'tdtc';
  String? coinType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Manage NFT"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: CustomScrollView(slivers: [
            sliverListButtons(context),
          ]),
        ));
  }

  SliverList sliverListButtons(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate(
      [
        /// Mint
        if (packageId != null)
          ElevatedButton(
              onPressed: () async {
                const String arg1 =
                    '0xe63ccd1373dc82db5fff3f74f78e314b5cd213408a3d6fbf9556345c040e5aef';
                const int arg2 = 10;
                const String arg3 =
                    '0x98c9819dacee1543eb9ee9bda8d625d1669f5ef784cfc65e4f04e6d2a89fd724';

                final tx = TransactionBlock();
                tx.setGasBudget(BigInt.from(10000000));
                tx.moveCall('$packageId::tdtc::mint', arguments: [
                  tx.pure(arg1),
                  tx.pureInt(arg2),
                  tx.pureAddress(arg3)
                ]);
                print('MAKE CALL!!!!!!!!!!!!!!!!!!!!!!!');

                final result =
                    await widget.client.signAndExecuteTransactionBlock(
                  account!,
                  tx,
                  requestType: ExecuteTransaction.WaitForLocalExecution,
                );
                print('RESULT CALL: ${result.digest}');
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  textStyle: const TextStyle(fontSize: 18)),
              child: const Text("Mint")),
      ],
    ));
  }
}
