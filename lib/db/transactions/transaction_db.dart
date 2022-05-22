import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management_app/models/transactions/transaction_model.dart';

const TRANSACTIONS_DB = 'transaction-database';

abstract class Transaction_Db_function {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getTransaction();
  Future<void> deleteTransaction(String id);
}

class TransactionDb implements Transaction_Db_function {
  TransactionDb.internal();
  static TransactionDb instance = TransactionDb.internal();
  factory TransactionDb() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier =
      ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final transactionDb = await Hive.openBox<TransactionModel>(TRANSACTIONS_DB);
    await transactionDb.put(obj.id, obj);
  }

  @override
  Future<List<TransactionModel>> getTransaction() async {
    final transactionDb = await Hive.openBox<TransactionModel>(TRANSACTIONS_DB);
    return transactionDb.values.toList();
  }

  Future<void> refresh() async {
    final _list = await getTransaction();
    _list.sort((first, second) => second.date.compareTo(first.date));
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(_list);
    transactionListNotifier.notifyListeners();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final transactionDb = await Hive.openBox<TransactionModel>(TRANSACTIONS_DB);
    await transactionDb.delete(id);
    refresh();
  }
}
