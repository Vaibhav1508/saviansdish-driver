import 'package:flutterrtdeliveryboyapp/db/common/ps_shared_preferences.dart';

class PsRepository {
  Future<dynamic> loadValueHolder() async{
    //PsSharedPreferences.instance.loadUserId('Mg Ba2');
   await PsSharedPreferences.instance.loadValueHolder();
  }

  Future<dynamic> replaceLoginUserId(String loginUserId) async{
   await PsSharedPreferences.instance.replaceLoginUserId(
      loginUserId,
    );
  }

  Future<dynamic> replaceLoginUserName(String loginUserName)async{
   await PsSharedPreferences.instance.replaceLoginUserName(
      loginUserName,
    );
  }

  Future<dynamic> replaceIsDeliveryBoy(String userFlag) async{
   await PsSharedPreferences.instance.replaceIsDeliveryBoy(
      userFlag,
    );
  }

  Future<dynamic> replaceNotiToken(String notiToken) async{
   await PsSharedPreferences.instance.replaceNotiToken(
      notiToken,
    );
  }

  Future<dynamic> replaceNotiMessage(String message) async{
   await PsSharedPreferences.instance.replaceNotiMessage(
      message,
    );
  }

  Future<dynamic> replaceNotiSetting(bool notiSetting) async{
   await PsSharedPreferences.instance.replaceNotiSetting(
      notiSetting,
    );
  }

  Future<dynamic> replaceDate(String startDate, String endDate) async{
   await PsSharedPreferences.instance.replaceDate(startDate, endDate);
  }

  Future<dynamic> replaceLoginUserData(
      String userIdToVerify,
      String userNameToVerify,
      String userEmailToVerify,
      String userPasswordToVerify,
      String userId,
      String deliveryBoyFlag) async{
   await PsSharedPreferences.instance.replaceLoginUserData(
        userIdToVerify,
        userNameToVerify,
        userEmailToVerify,
        userPasswordToVerify,
        userId,
        deliveryBoyFlag);
  }

  Future<dynamic> replaceVerifyUserData(String userIdToVerify, String userNameToVerify,
      String userEmailToVerify, String userPasswordToVerify)async{
   await PsSharedPreferences.instance.replaceVerifyUserData(userIdToVerify,
        userNameToVerify, userEmailToVerify, userPasswordToVerify);
  }

  Future<dynamic> replaceVersionForceUpdateData(bool appInfoForceUpdate) async{
   await PsSharedPreferences.instance.replaceVersionForceUpdateData(
      appInfoForceUpdate,
    );
  }

  Future<dynamic> replaceAppInfoData(String appInfoVersionNo, bool appInfoForceUpdate,
      String appInfoForceUpdateTitle, String appInfoForceUpdateMsg) async{
   await PsSharedPreferences.instance.replaceAppInfoData(appInfoVersionNo,
        appInfoForceUpdate, appInfoForceUpdateTitle, appInfoForceUpdateMsg);
  }

  Future<dynamic> replaceShopInfoValueHolderData(
    String overAllTaxLabel,
    String overAllTaxValue,
    String shippingTaxLabel,
    String shippingTaxValue,
    String shippingId,
    String shopId,
    String messenger,
    String whatsApp,
    String phone,
  ) async{
   await PsSharedPreferences.instance.replaceShopInfoValueHolderData(
        overAllTaxLabel,
        overAllTaxValue,
        shippingTaxLabel,
        shippingTaxValue,
        shippingId,
        shopId,
        messenger,
        whatsApp,
        phone);
  }

  Future<dynamic> replaceCheckoutEnable(
      String paypalEnabled,
      String stripeEnabled,
      String codEnabled,
      String bankEnabled,
      String standardShippingEnable,
      String zoneShippingEnable,
      String noShippingEnable) async{
   await PsSharedPreferences.instance.replaceCheckoutEnable(
        paypalEnabled,
        stripeEnabled,
        codEnabled,
        bankEnabled,
        standardShippingEnable,
        zoneShippingEnable,
        noShippingEnable);
  }

  Future<dynamic> replacePublishKey(String pubKey) async{
   await PsSharedPreferences.instance.replacePublishKey(pubKey);
  }

  Future<dynamic> replaceContactInformation(
      String contactPhone, String contactEmail, String contactWebsite) async{
   await PsSharedPreferences.instance
        .replaceContactInformation(contactPhone, contactEmail, contactWebsite);
  }

  Future<dynamic> replaceShop(String shopId, String shopName) async{
   await PsSharedPreferences.instance.replaceShop(shopId, shopName);
  }
}
