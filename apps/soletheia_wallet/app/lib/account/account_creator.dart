import 'package:application/account.dart';
import 'package:infrastructure/rust.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_creator.g.dart';

@riverpod
AccountCreator accountCreator(Ref ref) => const RustAccountCreator();
