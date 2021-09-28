import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_resource.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
import 'package:flutterrtdeliveryboyapp/api/ps_api_service.dart';
import 'package:flutterrtdeliveryboyapp/constant/ps_constants.dart';
import 'package:flutterrtdeliveryboyapp/db/shop_dao.dart';
import 'package:flutterrtdeliveryboyapp/db/shop_map_dao.dart';
import 'package:flutterrtdeliveryboyapp/repository/Common/ps_repository.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/holder/shop_parameter_holder.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/shop.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/shop_map.dart';
import 'package:sembast/sembast.dart';

class ShopRepository extends PsRepository {
  ShopRepository(
      {@required PsApiService psApiService, @required ShopDao shopDao}) {
    _psApiService = psApiService;
    _shopDao = shopDao;
  }
  String primaryKey = 'id';
  String mapKey = 'map_key';
  String tagIdKey = 'tag_id';
  PsApiService _psApiService;
  ShopDao _shopDao;

  void sinkShopListStream(
      StreamController<PsResource<List<Shop>>> shopListStream,
      PsResource<List<Shop>> dataList) {
    if (dataList != null && shopListStream != null) {
      shopListStream.sink.add(dataList);
    }
  }

  void sinkShopListByTagIdStream(
      StreamController<PsResource<List<Shop>>> shopListByTagIdStream,
      PsResource<List<Shop>> dataList) {
    if (dataList != null && shopListByTagIdStream != null) {
      shopListByTagIdStream.sink.add(dataList);
    }
  }

  Future<dynamic> insert(Shop shop) async {
    return _shopDao.insert(primaryKey, shop);
  }

  Future<dynamic> update(Shop shop) async {
    return _shopDao.update(shop);
  }

  Future<dynamic> delete(Shop shop) async {
    return _shopDao.delete(shop);
  }

  Future<dynamic> getShopList(
      StreamController<PsResource<List<Shop>>> shopListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      ShopParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final String paramKey = holder.getParamKey();
    final ShopMapDao shopMapDao = ShopMapDao.instance;

    // Load from Db and Send to UI
    sinkShopListStream(
        shopListStream,
        await _shopDao.getAllByMap(
            primaryKey, mapKey, paramKey, shopMapDao, ShopMap(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<Shop>> _resource =
          await _psApiService.getShopList(holder.toMap(), limit, offset);

      print('Param Key $paramKey');
      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<ShopMap> shopMapList = <ShopMap>[];
        int i = 0;
        for (Shop data in _resource.data) {
          shopMapList.add(ShopMap(
              id: data.id + paramKey,
              mapKey: paramKey,
              shopId: data.id,
              sorting: i++,
              addedDate: '2020'));
        }

        // Delete and Insert Map Dao
        print('Delete Key $paramKey');
        await shopMapDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
        print('Insert All Key $paramKey');
        await shopMapDao.insertAll(primaryKey, shopMapList);

        // Insert Shop
        await _shopDao.insertAll(primaryKey, _resource.data);

      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        // Delete and Insert Map Dao
        await shopMapDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
        }
      }
      // Load updated Data from Db and Send to UI
      sinkShopListStream(
          shopListStream,
          await _shopDao.getAllByMap(
              primaryKey, mapKey, paramKey, shopMapDao, ShopMap()));
    }
  }

  Future<dynamic> getNextPageShopList(
      StreamController<PsResource<List<Shop>>> shopListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      ShopParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    final String paramKey = holder.getParamKey();
    final ShopMapDao shopMapDao = ShopMapDao.instance;
    // Load from Db and Send to UI
    sinkShopListStream(
        shopListStream,
        await _shopDao.getAllByMap(
            primaryKey, mapKey, paramKey, shopMapDao, ShopMap(),
            status: status));
    if (isConnectedToInternet) {
      final PsResource<List<Shop>> _resource =
          await _psApiService.getShopList(holder.toMap(), limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<ShopMap> shopMapList = <ShopMap>[];
        final PsResource<List<ShopMap>> existingMapList = await shopMapDao
            .getAll(finder: Finder(filter: Filter.equals(mapKey, paramKey)));

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data.length + 1;
        }
        for (Shop data in _resource.data) {
          shopMapList.add(ShopMap(
              id: data.id + paramKey,
              mapKey: paramKey,
              shopId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        await shopMapDao.insertAll(primaryKey, shopMapList);

        // Insert Shop
        await _shopDao.insertAll(primaryKey, _resource.data);
      }
      sinkShopListStream(
          shopListStream,
          await _shopDao.getAllByMap(
              primaryKey, mapKey, paramKey, shopMapDao, ShopMap()));
    }
  }
}
