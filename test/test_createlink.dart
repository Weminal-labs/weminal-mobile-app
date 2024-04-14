import 'package:flutter_test/flutter_test.dart';
import 'package:sui/cryptography/ed25519_keypair.dart';
import 'package:sui/sui.dart';
import 'package:sui/sui_account.dart';
import 'package:weminal_app/zkSend/builder.dart';

final keyPair = Ed25519Keypair.fromMnemonics(
    "frozen okay holiday moon worth mushroom mix trap auto latin myth rapid");
final suiAccount = SuiAccount(keyPair);

void main() {
  test(
    'test createLink()',
    () async {
      await ZkSendLinkBuilder.createLink(suiAccount, 300000000);
    },
  );
  test(
    'test createLinkObject()',
    () async {
      String myLink = await ZkSendLinkBuilder.createLinkObject(
          bytes:
              'AAAEAA4NbmFtZSB0aWNrZXQgMQANDGRlcyB0aWNrZXQgMQBOTWh0dHBzOi8vY29pbnouY29tLnZuL3dwLWNvbnRlbnQvdXBsb2Fkcy8yMDIyLzEwL3N1aS1ibG9ja2NoYWluLXRodW1ibmFpbC53ZWJwACBR9KHjvaSMMFZW07+0bbInogKf315zivNB46KRGNCJygEAUfSh472kjDBWVtO/tG2yJ6ICn99ec4rzQeOikRjQicoFZXZlbnQKbmV3X3RpY2tldAAEAQAAAQEAAQIAAQMAUi4PRYJsmp7s1jJjmLDqWh8c6XYt7sqW/JR3tgBKNoUCAZeDoxpJ8Hm7S3E4vHzfywLP5ZDmG3aXwPU6LQuq/ewgAQAAAAAAACAgXnzq1M4hoDPUAb+oHrF5mxjNK5S0QWRZvzxyeVJzg4YMawmrLD4R7HjKkzciXY4mJ5WcmyPjIqDFPSVz83ucFwEAAAAAAAAg6dxPtUBY5Zi/WUSCM7v1MjqSsZlItxd/uKPV+HXnqGdSLg9FgmyanuzWMmOYsOpaHxzpdi3uypb8lHe2AEo2hegDAAAAAAAAkPZQAAAAAAAA',
          senderAddress:
              '0x89ef5e69e2f6dd0e759f15a13823098011cca2122d1c0225f5b6f3337be88485',
          zkSign:
              'BQNNMTEwMTA2MDY1MzA0NTQ0NjUwNDkxMTIxOTA1NDY2MjkxOTk2MTkzNjM2ODA5MjQzNTY1Mzc1MTMyODIzNjAxNjk4NzY5MjgxNzkyNThMMjAzOTQwMDY3NjgzNjMyMjEwOTMwNDQzNzI1NzQ4Nzc4NTExMjYzNDA4NDA3MDE2NjM5MTI3NzE2NDYwMzA3NTA0Nzk3ODExMTg5OQExAwJMNjA1OTYyNzg5OTYzMzkyMjE2NjUxMDM5NzU3NTIwODIxNDUxMjUwMjI0NDc4MTE1NjIzNzEyMjgzNDcwNDI1ODQ5MjEzNDcwNzQzNEw4Mjk5OTA2OTkyOTAyNzg3OTk0OTU1MTExMjQwOTgwNTYwNDMyNDg5MzAwMDQyNTgyMDYyNDU5Njc3NjIxNTMxOTI1Mjc1NzgyMjE4Ak0yMDQxNjI4MzAyMjg1MTQ5MjgzMzU2MDQwMTc4NzYyMzE3MzAxODAwMjc0NTgyNjM3OTQyNTkyNjkwODA5Mjg2ODk0MzkyNDI2NTI3M00xMDA4MzkwNDU3OTU1MjYxNTY2Nzk0MjMzOTA4ODUwNzE5NjI4NzUyNjEyOTYyMDg4NjcyMDcyOTEwNDk4NTg5MzM0MDAyNDYzMzM1NwIBMQEwA00yMDI5NDUyNDk5MzAyNjQwNDUyNDMzMjAyNTQ2NjI0MzIxMzM0ODc5MDU5NjU2NzIwMTIwMzU4MjQ5NjQ5NjQ4MzcwMTk1MjIyNjM5N00xMDcyNjMyOTU3NDAwNTA1MTI5NjcyMTM1MzA4Njk5MjA1OTg1MDUyNDA0NzcxMzAwODYwMjI5MDM1MDk4MDUwODI2OTcwOTcxNDM3MAExMXlKcGMzTWlPaUpvZEhSd2N6b3ZMMkZqWTI5MWJuUnpMbWR2YjJkc1pTNWpiMjBpTEMBZmV5SmhiR2NpT2lKU1V6STFOaUlzSW10cFpDSTZJamt6WWpRNU5URTJNbUZtTUdNNE4yTmpOMkUxTVRZNE5qSTVOREE1TnpBME1',
          suiObjectRef: SuiObjectRef(
              "CtMynByksfRDEmDGQ77WRfKSQbe9qEANTJaQetHGB8dV",
              "0xd8c1f5b9530abb3a454ed145740616fcfec0bca6ef735342560e254198f1e1a8",
              29091180),
          objectType:
              '0xfdba6d8e99368a97d27d4e797da45ef43fe47e90aa70f80d5eeaa2e5689bda64::event::Ticket');
      print(myLink);
    },
  );
}
