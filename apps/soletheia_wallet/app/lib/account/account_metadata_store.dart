import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'account_metadata.dart';

part 'account_metadata_store.g.dart';

@riverpod
AccountMetadataStore accountMetadataStore(Ref ref) =>
    const AccountMetadataStore();

class AccountMetadataStore {
  const AccountMetadataStore({this.directory = getApplicationSupportDirectory});

  final Future<Directory> Function() directory;

  Future<Directory> _accountsDirectory() async {
    final root = await directory();
    return Directory.fromUri(root.uri.resolve('accounts/'));
  }

  Future<List<AccountMetadata>> load() async {
    final dir = await _accountsDirectory();
    if (!await dir.exists()) return [];
    final records = <AccountMetadata>[];
    await for (final item in dir.list(followLinks: false)) {
      if (item is File && item.path.endsWith('.json')) {
        final json =
            jsonDecode(await item.readAsString()) as Map<String, dynamic>;
        records.add(AccountMetadata.fromJson(json));
      }
    }
    return records..sort((a, b) => a.address.compareTo(b.address));
  }

  Future<void> save(AccountMetadata record) async {
    final dir = await _accountsDirectory();
    await dir.create(recursive: true);
    final file = File.fromUri(dir.uri.resolve('${record.address}.json'));
    final temp = File('${file.path}.tmp');
    await temp.writeAsString(jsonEncode(record.toJson()), flush: true);
    await temp.rename(file.path);
  }
}
