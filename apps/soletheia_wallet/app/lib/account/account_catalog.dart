import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'account_metadata.dart';
import 'account_metadata_store.dart';

part 'account_catalog.g.dart';

@Riverpod(keepAlive: true)
class AccountCatalog extends _$AccountCatalog {
  @override
  List<AccountMetadata> build() => const [];

  Future<void> load() async {
    state = await ref.read(accountMetadataStoreProvider).load();
  }

  Future<void> save(AccountMetadata metadata) async {
    await ref.read(accountMetadataStoreProvider).save(metadata);
    state = [
      ...state.where((record) => record.address != metadata.address),
      metadata,
    ];
  }
}
