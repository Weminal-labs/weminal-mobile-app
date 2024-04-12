import 'package:flutter_test/flutter_test.dart';
import 'package:sui/builder/transaction_block.dart';
import 'package:sui/cryptography/ed25519_keypair.dart';
import 'package:sui/sui_account.dart';
import 'package:sui/sui_client.dart';
import 'package:sui/sui_urls.dart';
import 'package:sui/cryptography/keypair.dart';

void main() {
  test('test move call', () async {
    // final account = SuiAccount.fromMnemonics(mnemonics, SignatureScheme.Ed25519);
    final account = SuiAccount(Keypair);
    final client = SuiClient(SuiUrls.devnet);

    const packageObjectId = '0x...';
    final tx = TransactionBlock();
    tx.moveCall('$packageObjectId::nft::mint',
        arguments: [tx.pureString('Example NFT')]);

    final result = await client.signAndExecuteTransactionBlock(account, tx);
    print(result.digest);
  });
}
