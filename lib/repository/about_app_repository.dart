import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_resource.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
import 'package:flutterrtdeliveryboyapp/api/ps_api_service.dart';
import 'package:flutterrtdeliveryboyapp/constant/ps_constants.dart';
import 'package:flutterrtdeliveryboyapp/db/about_app_dao.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/about_app.dart';

import 'Common/ps_repository.dart';

class AboutAppRepository extends PsRepository {
  AboutAppRepository(
      {@required PsApiService psApiService, @required AboutAppDao aboutUsDao}) {
    _psApiService = psApiService;
    _aboutUsDao = aboutUsDao;
  }

  String primaryKey = 'about_id';
  PsApiService _psApiService;
  AboutAppDao _aboutUsDao;

  Future<dynamic> insert(AboutApp aboutUs) async {
    return _aboutUsDao.insert(primaryKey, aboutUs);
  }

  Future<dynamic> update(AboutApp aboutUs) async {
    return _aboutUsDao.update(aboutUs);
  }

  Future<dynamic> delete(AboutApp aboutUs) async {
    return _aboutUsDao.delete(aboutUs);
  }

  Future<dynamic> getAllAboutAppList(
      StreamController<PsResource<List<AboutApp>>> aboutUsListStream,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    aboutUsListStream.sink.add(await _aboutUsDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<AboutApp>> _resource =
          await _psApiService.getAboutAppDataList();

      if (_resource.status == PsStatus.SUCCESS) {
        await _aboutUsDao.deleteAll();
        await _aboutUsDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _aboutUsDao.deleteAll();
        }
      }
      aboutUsListStream.sink.add(await _aboutUsDao.getAll());
    }
  }

  Future<dynamic> getNextPageAboutAppList(
      StreamController<PsResource<List<AboutApp>>> aboutUsListStream,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    aboutUsListStream.sink.add(await _aboutUsDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<AboutApp>> _resource =
          await _psApiService.getAboutAppDataList();

      if (_resource.status == PsStatus.SUCCESS) {
        await _aboutUsDao.insertAll(primaryKey, _resource.data);
      }
      aboutUsListStream.sink.add(await _aboutUsDao.getAll());
    }
  }
}
