import 'dart:async';
import 'package:flutterrtdeliveryboyapp/repository/shop_info_repository.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_value_holder.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/shop_info.dart';
import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_resource.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
import 'package:flutterrtdeliveryboyapp/provider/common/ps_provider.dart';
import 'package:latlong/latlong.dart';

class ShopInfoProvider extends PsProvider {
  ShopInfoProvider(
      {@required ShopInfoRepository repo,
      @required this.ownerCode,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('ShopInfo Provider: $hashCode ($ownerCode) ');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    shopInfoListStream = StreamController<PsResource<ShopInfo>>.broadcast();
    subscription =
        shopInfoListStream.stream.listen((PsResource<ShopInfo> resource) async {
      _shopInfo = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        // Update to share preference
        // To submit tax and shipping tax to transaction

        if (_shopInfo != null && shopInfo.data != null) {
         await replaceShopInfoValueHolderData(
            _shopInfo.data.overallTaxLabel,
            _shopInfo.data.overallTaxValue,
            _shopInfo.data.shippingTaxLabel,
            _shopInfo.data.shippingTaxValue,
            _shopInfo.data.shippingId,
            _shopInfo.data.id,
            _shopInfo.data.messenger,
            _shopInfo.data.whapsappNo,
            _shopInfo.data.aboutPhone1,
          );

         await replaceCheckoutEnable(
              _shopInfo.data.paypalEnabled,
              _shopInfo.data.stripeEnabled,
              _shopInfo.data.codEmail,
              _shopInfo.data.banktransferEnabled,
              _shopInfo.data.standardShippingEnable,
              _shopInfo.data.zoneShippingEnable,
              _shopInfo.data.noShippingEnable);
         await replacePublishKey(_shopInfo.data.stripePublishableKey);

          notifyListeners();
        }
      }
    });
  }

  ShopInfoRepository _repo;
  String ownerCode;
  LatLng currentLatlng;
  PsValueHolder psValueHolder;

  PsResource<ShopInfo> _shopInfo =
      PsResource<ShopInfo>(PsStatus.NOACTION, '', null);

  PsResource<ShopInfo> get shopInfo => _shopInfo;
  StreamSubscription<PsResource<ShopInfo>> subscription;
  StreamController<PsResource<ShopInfo>> shopInfoListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('ShopInfo Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadShopInfo() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getShopInfo(
        shopInfoListStream, isConnectedToInternet, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> loadShopInfoById(String shopId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getShopInfoById(
        shopInfoListStream,shopId, isConnectedToInternet, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextShopInfoList(String shopId) async {
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      isConnectedToInternet = await Utils.checkInternetConnectivity();
      await _repo.getShopInfo(
          shopInfoListStream, isConnectedToInternet, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetShopInfoList(String shopId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getShopInfo(
        shopInfoListStream, isConnectedToInternet, PsStatus.BLOCK_LOADING);

    isLoading = false;
  }
}
