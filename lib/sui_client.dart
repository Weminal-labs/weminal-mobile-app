
import 'dart:typed_data';

import 'package:sui/builder/transaction_block.dart';
import 'package:sui/signers/signer_with_provider.dart';
import 'package:sui/sui_account.dart';
import 'package:sui/types/common.dart';
import 'package:sui/types/transactions.dart';

class SuiClient extends SignerWithProvider {
  late final SuiAccount? _account;

  SuiClient(
    String endpoint,
    {SuiAccount? account}
  ): super(endpoint) {
    _account = account;
  }

  SuiAccount? get account => _account;
  
  @override
  void setSigner(SuiAccount signer) {
    _account = signer;
  }

  @override
  SuiAddress getAddress() {
    if (_account == null) {
      throw ArgumentError("Please call setSigner method first", "signer");
    }
    return _account!.getAddress();
  }

  @override
  SignaturePubkeyPair signData(Uint8List data) {
    if (_account == null) {
      throw ArgumentError("Please call setSigner method first", "signer");
    }
    return _account!.signData(data);
  }

  Future<SuiTransactionBlockResponse> signAndExecuteTransactionBlock(
    SuiAccount signer,
    TransactionBlock transactionBlock,
    {
      BuildOptions? options,
      ExecuteTransaction requestType = ExecuteTransaction.WaitForEffectsCert,
      SuiTransactionBlockResponseOptions? responseOptions
    }
  ) async {
    options ??= BuildOptions(client: this);
    options.client ??= this;

    transactionBlock.setSenderIfNotSet(signer.getAddress());
    final transactionBytes = await transactionBlock.build(options);
    final signWithBytes = signer.keyPair.signTransactionBlock(transactionBytes);
    return await provider.executeTransactionBlock(
      signWithBytes.bytes, 
      [signWithBytes.signature],
      options: responseOptions,
      requestType: requestType
    );
  }


}