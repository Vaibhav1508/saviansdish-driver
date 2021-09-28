import 'dart:async';
import 'package:flutterrtdeliveryboyapp/repository/transaction_header_repository.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_header.dart';
import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_resource.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
import 'package:flutterrtdeliveryboyapp/provider/common/ps_provider.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_parameter_holder.dart';

class CompletedOrderProvider extends PsProvider {
  CompletedOrderProvider(
      {@required TransactionHeaderRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Completed order Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    transactionListStream =
        StreamController<PsResource<List<TransactionHeader>>>.broadcast();
    subscription = transactionListStream.stream
        .listen((PsResource<List<TransactionHeader>> resource) {
      updateOffset(resource.data.length);

      _transactionList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  TransactionHeaderRepository _repo;

  PsResource<List<TransactionHeader>> _transactionList =
      PsResource<List<TransactionHeader>>(
          PsStatus.NOACTION, '', <TransactionHeader>[]);
  PsResource<List<TransactionHeader>> get completedTransactionList =>
      _transactionList;

  StreamSubscription<PsResource<List<TransactionHeader>>> subscription;
  StreamController<PsResource<List<TransactionHeader>>> transactionListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Completed Order Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadCompletedOrderList(
      Map<dynamic, dynamic> jsonMap, TransactionParameterHolder holder) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllCompletedOrderList(
        transactionListStream,
        isConnectedToInternet,
        jsonMap,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        holder);
  }

  Future<dynamic> nextCompletedOrderList(
      Map<dynamic, dynamic> jsonMap, TransactionParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getAllCompletedOrderList(
          transactionListStream,
          isConnectedToInternet,
          jsonMap,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING,
          holder);
    }
  }

  Future<void> resetCompletedOrderList(
      Map<dynamic, dynamic> jsonMap, TransactionParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllCompletedOrderList(
        transactionListStream,
        isConnectedToInternet,
        jsonMap,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        holder);

    isLoading = false;
  }
}
