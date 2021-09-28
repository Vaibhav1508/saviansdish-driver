import 'dart:io';
import 'package:flutterrtdeliveryboyapp/viewobject/about_app.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/about_us.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_config.dart';
import 'package:flutterrtdeliveryboyapp/api/ps_url.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/api_status.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/default_photo.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/main_point.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/noti.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/ps_app_info.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/shop.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/shop_info.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_detail.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_header.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_status.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/user.dart';
import 'common/ps_api.dart';
import 'common/ps_resource.dart';

class PsApiService extends PsApi {
  ///
  /// App Info
  ///
  Future<PsResource<PSAppInfo>> postPsAppInfo(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_app_info_url}';
    return await postData<PSAppInfo, PSAppInfo>(PSAppInfo(), url, jsonMap);
  }

  ///
  /// User Register
  ///
  Future<PsResource<User>> postUserRegister(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_register_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Verify Email
  ///
  Future<PsResource<User>> postUserEmailVerify(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_email_verify_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Login
  ///
  Future<PsResource<User>> postUserLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_login_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// FB Login
  ///
  Future<PsResource<User>> postFBLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_fb_login_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// Google Login
  ///
  Future<PsResource<User>> postGoogleLogin(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_google_login_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// Apple Login
  ///
  Future<PsResource<User>> postAppleLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_apple_login_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Forgot Password
  ///
  Future<PsResource<ApiStatus>> postForgotPassword(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_forgot_password_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// User Change Password
  ///
  Future<PsResource<ApiStatus>> postChangePassword(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_change_password_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// User Profile Update
  ///
  Future<PsResource<User>> postProfileUpdate(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_update_profile_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Phone Login
  ///
  Future<PsResource<User>> postPhoneLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_phone_login_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Resend Code
  ///
  Future<PsResource<ApiStatus>> postResendCode(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_resend_code_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// Touch Count
  ///
  Future<PsResource<ApiStatus>> postTouchCount(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_touch_count_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// Get User
  ///
  Future<PsResource<List<User>>> getUser(String userId) async {
    final String url =
        '${PsUrl.ps_user_url}/api_key/${PsConfig.ps_api_key}/user_id/$userId';

    return await getServerCall<User, List<User>>(User(), url);
  }

  Future<PsResource<User>> postImageUpload(
      String userId, String platformName, File imageFile) async {
    const String url = '${PsUrl.ps_image_upload_url}';

    return postUploadImage<User, User>(
        User(), url, userId, platformName, imageFile);
  }

  ///
  /// About App
  ///
  Future<PsResource<List<AboutApp>>> getAboutAppDataList() async {
    const String url =
        '${PsUrl.ps_about_app_url}/api_key/${PsConfig.ps_api_key}/';
    return await getServerCall<AboutApp, List<AboutApp>>(AboutApp(), url);
  }

  //noti
  Future<PsResource<List<Noti>>> getNotificationList(
      Map<dynamic, dynamic> paramMap, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_noti_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

    return await postData<Noti, List<Noti>>(Noti(), url, paramMap);
  }

  ///
  /// Shop
  ///
  Future<PsResource<List<Shop>>> getShopList(
      Map<dynamic, dynamic> paramMap, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_shop_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

    return await postData<Shop, List<Shop>>(Shop(), url, paramMap);
  }

  ///
  /// About Us
  ///
  Future<PsResource<List<AboutUs>>> getAboutUsDataList() async {
    const String url =
        '${PsUrl.ps_about_us_url}/api_key/${PsConfig.ps_api_key}/';
    return await getServerCall<AboutUs, List<AboutUs>>(AboutUs(), url);
  }

  ///
  ///ShopInfo
  ///
  Future<PsResource<ShopInfo>> getShopInfo() async {
    const String url =
        '${PsUrl.ps_shop_info_url}/api_key/${PsConfig.ps_api_key}';
    return await getServerCall<ShopInfo, ShopInfo>(ShopInfo(), url);
  }

  ///
  ///ShopInfo
  ///
  Future<PsResource<ShopInfo>> getShopInfoById(String shopId) async {
    final String url =
        '${PsUrl.ps_shop_info_byId_url}/api_key/${PsConfig.ps_api_key}/id/$shopId';
    return await getServerCall<ShopInfo, ShopInfo>(ShopInfo(), url);
  }

  ///Setting
  ///
  ///
  Future<PsResource<MainPoint>> getAllPoints(
    String deliveryBoyLat,
    String deliveryBoyLng,
    String orderLat,
    String orderLng,
  ) async {
    final String url =
        'http://router.project-osrm.org/trip/v1/driving/$deliveryBoyLng,$deliveryBoyLat;$orderLng,$orderLat?overview=simplified&steps=true';
    return await getSpecificServerCall<MainPoint, MainPoint>(MainPoint(), url);
  }

  Future<PsResource<List<TransactionDetail>>> getTransactionDetail(
      String id, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_transactionDetail_url}/api_key/${PsConfig.ps_api_key}/transactions_header_id/$id/limit/$limit/offset/$offset';
    print(url);
    return await getServerCall<TransactionDetail, List<TransactionDetail>>(
        TransactionDetail(), url);
  }

  Future<PsResource<List<TransactionStatus>>> getTransactionStatusList(
      int limit, int offset) async {
    final String url =
        '${PsUrl.ps_transaction_status_list_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';
    print(url);
    return await getServerCall<TransactionStatus, List<TransactionStatus>>(
        TransactionStatus(), url);
  }

  Future<PsResource<TransactionHeader>> postTransactionSubmit(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_transaction_submit_url}';
    return await postData<TransactionHeader, TransactionHeader>(
        TransactionHeader(), url, jsonMap);
  }

  Future<PsResource<TransactionHeader>> postTransactionStatusUpdate(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_update_trans_status_url}';
    return await postData<TransactionHeader, TransactionHeader>(
        TransactionHeader(), url, jsonMap);
  }

  Future<PsResource<ApiStatus>> rawRegisterNotiToken(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_noti_register_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  Future<PsResource<ApiStatus>> rawUnRegisterNotiToken(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_noti_unregister_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  Future<PsResource<Noti>> postNoti(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_noti_post_url}';
    return await postData<Noti, Noti>(Noti(), url, jsonMap);
  }

  ///
  /// Gallery
  ///
  Future<PsResource<List<DefaultPhoto>>> getImageList(
      String parentImgId,
      // String imageType,
      int limit,
      int offset) async {
    final String url =
        '${PsUrl.ps_gallery_url}/api_key/${PsConfig.ps_api_key}/img_parent_id/$parentImgId/limit/$limit/offset/$offset';

    return await getServerCall<DefaultPhoto, List<DefaultPhoto>>(
        DefaultPhoto(), url);
  }

  ///
  /// Contact
  ///
  Future<PsResource<ApiStatus>> postContactUs(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_contact_us_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// Payment Status
  ///
  Future<PsResource<TransactionHeader>> postPaymentStatus(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_payment_status_url}';
    return await postData<TransactionHeader, TransactionHeader>(
        TransactionHeader(), url, jsonMap);
  }

  ///
  /// Completed Order
  ///
  Future<PsResource<List<TransactionHeader>>> postCompletedOrderList(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_completed_order_url}';
    return await postData<TransactionHeader, List<TransactionHeader>>(
        TransactionHeader(), url, jsonMap);
  }

  ///
  /// Pending Order
  ///
  Future<PsResource<List<TransactionHeader>>> postPendingOrderList(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_pending_order_url}';
    return await postData<TransactionHeader, List<TransactionHeader>>(
        TransactionHeader(), url, jsonMap);
  }

  ///
  /// Token
  ///
  Future<PsResource<ApiStatus>> getToken(String shopId) async {
    final String url =
        '${PsUrl.ps_token_url}/api_key/${PsConfig.ps_api_key}/shop_id/$shopId';
    return await getServerCall<ApiStatus, ApiStatus>(ApiStatus(), url);
  }
}
