import 'package:application/mnemonic.dart';
import 'package:infrastructure/rust.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mnemonic_generator.g.dart';

@riverpod
MnemonicGenerator mnemonicGenerator(Ref ref) => const RustMnemonicGenerator();
