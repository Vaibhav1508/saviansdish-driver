import 'dart:async';
import 'package:flutterrtdeliveryboyapp/repository/transaction_header_repository.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_value_holder.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_header.dart';
import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_resource.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
import 'package:flutterrtdeliveryboyapp/provider/common/ps_provider.dart';

class TransactionHeaderProvider extends PsProvider {
  TransactionHeaderProvider(
      {@required TransactionHeaderRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Pending order Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    //
    transactionHeaderStream =
        StreamController<PsResource<TransactionHeader>>.broadcast();
    subscriptionObject = transactionHeaderStream.stream
        .listen((PsResource<TransactionHeader> resource) {
      _transactionHeader = resource;

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
  PsValueHolder psValueHolder;

  PsResource<TransactionHeader> get transactionHeader => _transactionHeader;
  PsResource<TransactionHeader> _transactionHeader =
      PsResource<TransactionHeader>(PsStatus.NOACTION, '', null);
  StreamSubscription<PsResource<TransactionHeader>> subscriptionObject;
  StreamController<PsResource<TransactionHeader>> transactionHeaderStream;

  @override
  void dispose() {
    subscriptionObject.cancel();
    isDispose = true;
    print('Transaction Header Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postTransactionStatusUpdate(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _transactionHeader = await _repo.postTransactionStatusUpdate(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _transactionHeader;
  }
}
