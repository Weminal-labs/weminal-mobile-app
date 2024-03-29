import 'package:another_flushbar/flushbar.dart';
import 'package:example/contracts/contract_bytes.dart';
import 'package:example/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:sui/signers/txn_data_serializers/txn_data_serializer.dart';
import 'package:sui/sui_client.dart';
import 'package:sui/types/objects.dart';
import 'package:sui/types/transactions.dart';
import 'package:sui/sui.dart';
import 'package:sui/types/validator.dart';

class ManagedNFT extends StatefulWidget {
  const ManagedNFT({required this.client, Key? key}) : super(key: key);

  final SuiClient client;

  @override
  State<StatefulWidget> createState() => _ManagedNFTState();
}

class _ManagedNFTState extends State<ManagedNFT> {
  SuiAccount? account;
  SuiAccount? zkAccount;

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
      '0xade93de5f8b2fef53cc9fcc0f30b3a2b27fc073e36820d37f52a01eba379dd50';
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
                const String object =
                    '0x9c453808a7dfc7b41f876cce085b6e81fff8e182dce079067eb237caf67fe6e7';
                const int arg2 = 10;
                const String reciver =
                    '0x02b951e9357d5d6da406803e3bcacd2596808ffe733d40a171a8ea816037d1b0';

                final tx = TransactionBlock();
                tx.setGasBudget(BigInt.from(10000000));
                tx.moveCall('$packageId::tdtc::mint', arguments: [
                  tx.pure(object),
                  tx.pureInt(arg2),
                  tx.pureAddress(reciver)
                ]);
                print('MAKE CALL!!!!!!!!!!!!!!!!!!!!!!!');

                SuiClient suiClient = SuiClient(SuiUrls.devnet);
                final result = await suiClient.signAndExecuteTransactionBlock(
                  zkAccount!,
                  tx,
                  requestType: ExecuteTransaction.WaitForLocalExecution,
                );
                print('RESULT CALL: ${result.digest}');

                SuiSystemStateSummary suiSystemStateSumary =
                    await suiClient.getLatestSuiSystemState();
                print(
                    'suiSystemStateSumary.epoch: ${suiSystemStateSumary.epoch}');
                print(
                    'suiSystemStateSumary.epoch: ${suiSystemStateSumary.epochDurationMs}');
                print(
                    'suiSystemStateSumary.epochStartTimestampMs: ${suiSystemStateSumary.epochStartTimestampMs}');
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  textStyle: const TextStyle(fontSize: 18)),
              child: const Text("Mint")),
      ],
    ));
  }
}
