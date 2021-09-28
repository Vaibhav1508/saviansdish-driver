import 'dart:async';
import 'package:flutterrtdeliveryboyapp/db/point_dao.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/main_point.dart';
import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_resource.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
import 'package:flutterrtdeliveryboyapp/api/ps_api_service.dart';
import 'Common/ps_repository.dart';

class PointRepository extends PsRepository {
  PointRepository(
      {@required PsApiService psApiService, @required PointDao pointDao}) {
    _psApiService = psApiService;
    _pointDao = pointDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  PointDao _pointDao;

  Future<dynamic> insert(MainPoint mainPoint) async {
    return _pointDao.insert(primaryKey, mainPoint);
  }

  Future<dynamic> update(MainPoint mainPoint) async {
    return _pointDao.update(mainPoint);
  }

  Future<dynamic> delete(MainPoint mainPoint) async {
    return _pointDao.delete(mainPoint);
  }

  Future<dynamic> getAllPoints(
      StreamController<PsResource<MainPoint>> mainPointListStream,
      String deliveryBoyLat,
      String deliveryBoyLng,
      String orderLat,
      String orderLng,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // mainPointListStream.sink.add(await _pointDao.getOne(status: status));

    if (isConnectedToInternet) {
      final PsResource<MainPoint> _resource = await _psApiService.getAllPoints(
        deliveryBoyLat,
        deliveryBoyLng,
        orderLat,
        orderLng,
      );

      if (_resource.status == PsStatus.SUCCESS) {
        await _pointDao.deleteAll();
        await _pointDao.insert(primaryKey, _resource.data);
      }
      mainPointListStream.sink.add(await _pointDao.getOne());
    }
  }
}
