import 'dart:async';
import 'package:flutterrtdeliveryboyapp/repository/transaction_status_repository.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_value_holder.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_header.dart';
import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_resource.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
import 'package:flutterrtdeliveryboyapp/provider/common/ps_provider.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_status.dart';

class TransactionStatusProvider extends PsProvider {
  TransactionStatusProvider(
      {@required TransactionStatusRepository repo,
      this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('Transaction Status Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    transactionDetailListStream =
        StreamController<PsResource<List<TransactionStatus>>>.broadcast();
    subscription = transactionDetailListStream.stream
        .listen((PsResource<List<TransactionStatus>> resource) {
      updateOffset(resource.data.length);

      _transactionDetailList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  TransactionStatusRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<TransactionStatus>> _transactionDetailList =
      PsResource<List<TransactionStatus>>(
          PsStatus.NOACTION, '', <TransactionStatus>[]);

  PsResource<List<TransactionStatus>> get transactionStatusList =>
      _transactionDetailList;
  StreamSubscription<PsResource<List<TransactionStatus>>> subscription;
  StreamController<PsResource<List<TransactionStatus>>>
      transactionDetailListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Transaction Status Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadTransactionStatusList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllTransactionStatusList(transactionDetailListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
  }

  // Future<dynamic> nextTransactionStatusList(
  //     TransactionHeader transaction) async {
  //   isConnectedToInternet = await Utils.checkInternetConnectivity();

  //   if (!isLoading && !isReachMaxData) {
  //     super.isLoading = true;
  //     await _repo.getNextPageTransactionStatusList(
  //         transactionDetailListStream,
  //         transaction,
  //         isConnectedToInternet,
  //         limit,
  //         offset,
  //         PsStatus.PROGRESS_LOADING);
  //   }
  // }

  Future<void> resetTransactionStatusList(TransactionHeader transaction) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllTransactionStatusList(transactionDetailListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
