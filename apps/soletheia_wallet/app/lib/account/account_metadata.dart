import 'dart:convert';

import 'package:application/application.dart';
import 'package:bs58/bs58.dart';

class AccountMetadata {
  const AccountMetadata(this.account, this.derivationPath);

  final CreatedAccount account;
  final DerivationPath derivationPath;

  String get address => base58.encode(account.address.bytes);

  Map<String, String> toJson() {
    return {
      'address': address,
      'mnemonicId': base64Encode(account.mnemonicId.bytes),
      'derivationPath': derivationPath.value,
    };
  }

  factory AccountMetadata.fromJson(Map<String, dynamic> json) {
    return AccountMetadata(
      CreatedAccount(
        address: AccountAddress(base58.decode(json['address'] as String)),
        mnemonicId: MnemonicId(base64Decode(json['mnemonicId'] as String)),
      ),
      DerivationPath.parse(json['derivationPath'] as String),
    );
  }
}
