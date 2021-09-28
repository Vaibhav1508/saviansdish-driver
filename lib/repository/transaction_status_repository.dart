import 'dart:async';
import 'package:flutterrtdeliveryboyapp/constant/ps_constants.dart';
import 'package:flutterrtdeliveryboyapp/db/transaction_status_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_resource.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
import 'package:flutterrtdeliveryboyapp/api/ps_api_service.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_status.dart';

import 'Common/ps_repository.dart';

class TransactionStatusRepository extends PsRepository {
  TransactionStatusRepository(
      {@required PsApiService psApiService,
      @required TransactionStatusDao transactionStatusDao}) {
    _psApiService = psApiService;
    _transactionStatusDao = transactionStatusDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  TransactionStatusDao _transactionStatusDao;

  Future<dynamic> insert(TransactionStatus transaction) async {
    return _transactionStatusDao.insert(primaryKey, transaction);
  }

  Future<dynamic> update(TransactionStatus transaction) async {
    return _transactionStatusDao.update(transaction);
  }

  Future<dynamic> delete(TransactionStatus transaction) async {
    return _transactionStatusDao.delete(transaction);
  }

  Future<dynamic> getAllTransactionStatusList(
      StreamController<PsResource<List<TransactionStatus>>>
          transactionDetailListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    transactionDetailListStream.sink
        .add(await _transactionStatusDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<TransactionStatus>> _resource =
          await _psApiService.getTransactionStatusList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _transactionStatusDao.deleteAll();
        await _transactionStatusDao.insertAll(primaryKey, _resource.data);
      }else{
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _transactionStatusDao.deleteAll();
        }
      }
      transactionDetailListStream.sink
          .add(await _transactionStatusDao.getAll());
    }
  }
}
