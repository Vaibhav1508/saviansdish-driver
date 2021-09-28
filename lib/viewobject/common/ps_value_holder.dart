import 'package:flutter/cupertino.dart';

class PsValueHolder {
  PsValueHolder({
    @required this.loginUserId,
    @required this.loginUserName,
    @required this.userIdToVerify,
    @required this.userNameToVerify,
    @required this.userEmailToVerify,
    @required this.userPasswordToVerify,
    @required this.deviceToken,
    @required this.notiSetting,
    @required this.overAllTaxLabel,
    @required this.overAllTaxValue,
    @required this.shippingTaxLabel,
    @required this.shopId,
    @required this.shopName,
    @required this.messenger,
    @required this.whatsApp,
    @required this.phone,
    @required this.shippingTaxValue,
    @required this.appInfoVersionNo,
    @required this.appInfoForceUpdate,
    @required this.appInfoForceUpdateTitle,
    @required this.appInfoForceUpdateMsg,
    @required this.startDate,
    @required this.endDate,
    @required this.paypalEnabled,
    @required this.stripeEnabled,
    @required this.codEnabled,
    @required this.bankEnabled,
    @required this.publishKey,
    @required this.shippingId,
    @required this.standardShippingEnable,
    @required this.zoneShippingEnable,
    @required this.noShippingEnable,
    @required this.isDeliveryBoy,
    @required this.contactPhone,
    @required this.contactEmail,
    @required this.contactWebsite,
  });
  String loginUserId;
  String loginUserName;
  String userIdToVerify;
  String userNameToVerify;
  String userEmailToVerify;
  String userPasswordToVerify;
  String deviceToken;
  bool notiSetting;
  String overAllTaxLabel;
  String overAllTaxValue;
  String shippingTaxLabel;
  String shopId;
  String shopName;
  String messenger;
  String whatsApp;
  String phone;
  String shippingTaxValue;
  String appInfoVersionNo;
  bool appInfoForceUpdate;
  String appInfoForceUpdateTitle;
  String appInfoForceUpdateMsg;
  String startDate;
  String endDate;
  String paypalEnabled;
  String stripeEnabled;
  String codEnabled;
  String bankEnabled;
  String publishKey;
  String shippingId;
  String standardShippingEnable;
  String zoneShippingEnable;
  String noShippingEnable;
  String isDeliveryBoy;
  String contactPhone;
  String contactEmail;
  String contactWebsite;

  bool isUserToLogin() {
    return (loginUserId == null || loginUserId == '') && (!isUserToVerfity());
  }

  bool isUserToVerfity() {
    return userIdToVerify != null && userIdToVerify != '';
  }
}
