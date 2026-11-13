import 'unit_of_work.dart';

abstract interface class UnitOfWorkFactory {
  /// Commits when [operation] completes and rolls back when it throws.
  Future<T> run<T>(Future<T> Function(UnitOfWork uow) operation);
}
