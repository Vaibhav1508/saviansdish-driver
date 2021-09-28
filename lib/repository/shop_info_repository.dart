import 'dart:async';
import 'package:flutterrtdeliveryboyapp/db/shop_info_dao.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/shop_info.dart';
import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_resource.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
import 'package:flutterrtdeliveryboyapp/api/ps_api_service.dart';
import 'package:sembast/sembast.dart';
import 'Common/ps_repository.dart';

class ShopInfoRepository extends PsRepository {
  ShopInfoRepository(
      {@required PsApiService psApiService,
      @required ShopInfoDao shopInfoDao}) {
    _psApiService = psApiService;
    _shopInfoDao = shopInfoDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  ShopInfoDao _shopInfoDao;

  Future<dynamic> insert(ShopInfo shopInfo) async {
    return _shopInfoDao.insert(primaryKey, shopInfo);
  }

  Future<dynamic> update(ShopInfo shopInfo) async {
    return _shopInfoDao.update(shopInfo);
  }

  Future<dynamic> delete(ShopInfo shopInfo) async {
    return _shopInfoDao.delete(shopInfo);
  }

  Future<dynamic> getShopInfo(
      StreamController<PsResource<ShopInfo>> shopInfoListStream,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    shopInfoListStream.sink.add(await _shopInfoDao.getOne(status: status));

    if (isConnectedToInternet) {
      final PsResource<ShopInfo> _resource = await _psApiService.getShopInfo();

      if (_resource.status == PsStatus.SUCCESS) {
        await _shopInfoDao.deleteAll();
        await _shopInfoDao.insert(primaryKey, _resource.data);
      }
      shopInfoListStream.sink.add(await _shopInfoDao.getOne());
    }
  }

  Future<dynamic> getShopInfoById(
      StreamController<PsResource<ShopInfo>> shopInfoListStream,
      String shopId,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('id', shopId));
    shopInfoListStream.sink
        .add(await _shopInfoDao.getOne(finder: finder, status: status));

    if (isConnectedToInternet) {
      final PsResource<ShopInfo> _resource =
          await _psApiService.getShopInfoById(shopId);

      if (_resource.status == PsStatus.SUCCESS) {
        await _shopInfoDao.deleteAll();
        await _shopInfoDao.insert(primaryKey, _resource.data);
        shopInfoListStream.sink.add(await _shopInfoDao.getOne());
      }
    }
  }
}
