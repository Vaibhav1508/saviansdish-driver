import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_resource.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
import 'package:flutterrtdeliveryboyapp/api/ps_api_service.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_header.dart';

import 'Common/ps_repository.dart';

class PaymentStatusRepository extends PsRepository {
  PaymentStatusRepository({
    @required PsApiService psApiService,
  }) {
    _psApiService = psApiService;
  }
  String primaryKey = 'id';
  PsApiService _psApiService;

  Future<PsResource<TransactionHeader>> postPaymentStatus(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final String jsonMapData = jsonMap.toString();
    print(jsonMapData);

    final PsResource<TransactionHeader> _resource =
        await _psApiService.postPaymentStatus(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<TransactionHeader>> completer =
          Completer<PsResource<TransactionHeader>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
