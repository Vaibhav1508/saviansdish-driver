import 'dart:async';
import 'package:flutterrtdeliveryboyapp/repository/payment_status_repository.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_resource.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
import 'package:flutterrtdeliveryboyapp/provider/common/ps_provider.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_header.dart';

class PaymentStatusProvider extends PsProvider {
  PaymentStatusProvider({@required PaymentStatusRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('PaymentStatus Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  PaymentStatusRepository _repo;

  PsResource<TransactionHeader> _paymentStatus =
      PsResource<TransactionHeader>(PsStatus.NOACTION, '', null);
  PsResource<TransactionHeader> get paymentStatus => _paymentStatus;

  @override
  void dispose() {
    isDispose = true;
    print('TransactionHeader Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postPaymentStatus(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _paymentStatus = await _repo.postPaymentStatus(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _paymentStatus;
  }
}
