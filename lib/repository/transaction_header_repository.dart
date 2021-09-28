import 'dart:async';
import 'package:flutterrtdeliveryboyapp/constant/ps_constants.dart';
import 'package:flutterrtdeliveryboyapp/db/transaction_header_dao.dart';
import 'package:flutterrtdeliveryboyapp/db/transaction_map_dao.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_header.dart';
import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_resource.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
import 'package:flutterrtdeliveryboyapp/api/ps_api_service.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_map.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_parameter_holder.dart';
import 'package:sembast/sembast.dart';

import 'Common/ps_repository.dart';

class TransactionHeaderRepository extends PsRepository {
  TransactionHeaderRepository(
      {@required PsApiService psApiService,
      @required TransactionHeaderDao transactionHeaderDao}) {
    _psApiService = psApiService;
    _transactionHeaderDao = transactionHeaderDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  String mapKey = 'map_key';
  TransactionHeaderDao _transactionHeaderDao;

  Future<dynamic> insert(TransactionHeader transaction) async {
    return _transactionHeaderDao.insert(primaryKey, transaction);
  }

  Future<dynamic> update(TransactionHeader transaction) async {
    return _transactionHeaderDao.update(transaction);
  }

  Future<dynamic> delete(TransactionHeader transaction) async {
    return _transactionHeaderDao.delete(transaction);
  }

  void sinkTransactionListStream(
      StreamController<PsResource<List<TransactionHeader>>> productListStream,
      PsResource<List<TransactionHeader>> dataList) {
    if (dataList != null && productListStream != null) {
      productListStream.sink.add(dataList);
    }
  }

  Future<dynamic> getAllCompletedOrderList(
      StreamController<PsResource<List<TransactionHeader>>>
          completedOrderListStream,
      bool isConnectedToInternet,
      Map<dynamic, dynamic> jsonMap,
      int limit,
      int offset,
      PsStatus status,
      TransactionParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final String paramKey = holder.getParamKey();
    final TransactionMapDao productMapDao = TransactionMapDao.instance;

    // Load from Db and Send to UI
    sinkTransactionListStream(
        completedOrderListStream,
        await _transactionHeaderDao.getAllByMap(
            primaryKey, mapKey, paramKey, productMapDao, TransactionMap(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<TransactionHeader>> _resource =
          await _psApiService.postCompletedOrderList(jsonMap);

      // print('Param Key $paramKey');
      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<TransactionMap> productMapList = <TransactionMap>[];
        int i = 0;
        for (TransactionHeader data in _resource.data) {
          productMapList.add(TransactionMap(
              id: data.id + paramKey,
              mapKey: paramKey,
              transactionId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        // Delete and Insert Map Dao
        // print('Delete Key $paramKey');
        await productMapDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
        // print('Insert All Key $paramKey');
        await productMapDao.insertAll(primaryKey, productMapList);

        // Insert Product
        await _transactionHeaderDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        // Delete and Insert Map Dao
        await productMapDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
        }
      }
      // Load updated Data from Db and Send to UI
      sinkTransactionListStream(
          completedOrderListStream,
          await _transactionHeaderDao.getAllByMap(
              primaryKey, mapKey, paramKey, productMapDao, TransactionMap()));
    }
  }

  Future<dynamic> getAllPendingOrderList(
      StreamController<PsResource<List<TransactionHeader>>>
          pendingOrderListStream,
      bool isConnectedToInternet,
      Map<dynamic, dynamic> jsonMap,
      int limit,
      int offset,
      PsStatus status,
      TransactionParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final String paramKey = holder.getParamKey();
    final TransactionMapDao productMapDao = TransactionMapDao.instance;

    // Load from Db and Send to UI
    sinkTransactionListStream(
        pendingOrderListStream,
        await _transactionHeaderDao.getAllByMap(
            primaryKey, mapKey, paramKey, productMapDao, TransactionMap(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<TransactionHeader>> _resource =
          await _psApiService.postPendingOrderList(jsonMap);

      // print('Param Key $paramKey');
      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<TransactionMap> productMapList = <TransactionMap>[];
        int i = 0;
        for (TransactionHeader data in _resource.data) {
          productMapList.add(TransactionMap(
              id: data.id + paramKey,
              mapKey: paramKey,
              transactionId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        // Delete and Insert Map Dao
        // print('Delete Key $paramKey');
        await productMapDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
        // print('Insert All Key $paramKey');
        await productMapDao.insertAll(primaryKey, productMapList);

        // Insert Product
        await _transactionHeaderDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        // Delete and Insert Map Dao
        await productMapDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
        }
      }
      // Load updated Data from Db and Send to UI
      sinkTransactionListStream(
          pendingOrderListStream,
          await _transactionHeaderDao.getAllByMap(
              primaryKey, mapKey, paramKey, productMapDao, TransactionMap()));
    }
  }

  Future<PsResource<TransactionHeader>> postTransactionSubmit(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final String jsonMapData = jsonMap.toString();
    print(jsonMapData);

    final PsResource<TransactionHeader> _resource =
        await _psApiService.postTransactionSubmit(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<TransactionHeader>> completer =
          Completer<PsResource<TransactionHeader>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<TransactionHeader>> postTransactionStatusUpdate(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final String jsonMapData = jsonMap.toString();
    print(jsonMapData);

    final PsResource<TransactionHeader> _resource =
        await _psApiService.postTransactionStatusUpdate(jsonMap);
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
