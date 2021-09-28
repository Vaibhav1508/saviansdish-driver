import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/constant/route_paths.dart';
import 'package:flutterrtdeliveryboyapp/ui/active_order/active_order_container_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/app_info/app_info_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/app_loading/app_loading_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/force_update/force_update_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/gallery/detail/gallery_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/gallery/shop_gallery_grid_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/language/list/language_list_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/noti/detail/noti_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/noti/notification_setting/notification_setting_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/order/detail/order_item_list_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/order/history/order_history_container_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/setting/setting_container_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/setting/setting_privacy_policy_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/shop_dashboard/core_dashboard/shop_dashboard_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/shop_info/shop_info_container_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/user/edit_profile/edit_profile_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/user/forgot_password/forgot_password_container_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/user/login/login_container_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/user/more/more_container_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/user/password_update/change_password_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/user/phone/sign_in/phone_sign_in_container_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/user/phone/verify_phone/verify_phone_container_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/user/profile/profile_container_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/user/register/register_container_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/user/verify/verify_email_container_view.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/default_photo.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/deli_boy_version.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/holder/intent_holder/verify_phone_internt_holder.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/noti.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/shop_info.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_header.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              AppLoadingView());
    case '${RoutePaths.shopDashboard}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ShopDashboardView());
    case '${RoutePaths.force_update}':
      final Object args = settings.arguments;
      final DeliBoyVersion deliBoyVersion = args ?? DeliBoyVersion;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ForceUpdateView(deliBoyVersion: deliBoyVersion));
    case '${RoutePaths.user_register_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              RegisterContainerView());
    case '${RoutePaths.login_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              LoginContainerView());
    case '${RoutePaths.user_verify_email_container}':
      final Object args = settings.arguments;
      final String userId = args ?? String;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              VerifyEmailContainerView(userId: userId));
    case '${RoutePaths.user_forgot_password_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ForgotPasswordContainerView());
    case '${RoutePaths.user_phone_signin_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              PhoneSignInContainerView());
    case '${RoutePaths.user_phone_verify_container}':
      final Object args = settings.arguments;

      final VerifyPhoneIntentHolder verifyPhoneIntentParameterHolder =
          args ?? VerifyPhoneIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              VerifyPhoneContainerView(
                userName: verifyPhoneIntentParameterHolder.userName,
                phoneNumber: verifyPhoneIntentParameterHolder.phoneNumber,
                phoneId: verifyPhoneIntentParameterHolder.phoneId,
              ));
    case '${RoutePaths.user_update_password}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ChangePasswordView());
    case '${RoutePaths.galleryDetail}':
      final Object args = settings.arguments;
      final DefaultPhoto selectedDefaultImage = args ?? DefaultPhoto;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              GalleryView(selectedDefaultImage: selectedDefaultImage));
    case '${RoutePaths.profile_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ProfileContainerView());
    case '${RoutePaths.languageList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              LanguageListView());
    case '${RoutePaths.appinfo}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => AppInfoView());
    case '${RoutePaths.notiSetting}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              NotificationSettingView());
    case '${RoutePaths.setting}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              SettingContainerView());
    case '${RoutePaths.more}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object args = settings.arguments;
        final String userName = args ?? String;
        return MoreContainerView(userName: userName);
      });
    case '${RoutePaths.noti}':
      final Object args = settings.arguments;
      final Noti noti = args ?? Noti;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              NotiView(noti: noti));
    case '${RoutePaths.privacyPolicy}':
      final Object args = settings.arguments;
      final int checkPolicyType = args ?? int;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              SettingPrivacyPolicyView(
                checkPolicyType: checkPolicyType,
              ));

    case '${RoutePaths.transactionDetail}':
      final Object args = settings.arguments;
      final TransactionHeader transaction = args ?? TransactionHeader;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              OrderItemListView(
                intentTransaction: transaction,
              ));

    case '${RoutePaths.editProfile}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              EditProfileView());

    case '${RoutePaths.shop_info_container}':
      final Object args = settings.arguments;
      String shopId = '';
      if(args != null) {
        shopId = args ?? String;
      }
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ShopInfoContainerView(shopId: shopId));

    case '${RoutePaths.single_shop_info_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              const ShopInfoContainerView(shopId: ''));

    case '${RoutePaths.shopGalleryGrid}':
      final Object args = settings.arguments;
      final ShopInfo shopInfo = args ?? ShopInfo;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ShopGalleryGridView(shopInfo: shopInfo));

    case '${RoutePaths.completedTransactionList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CompletedOrderListContainerView());

    case '${RoutePaths.activeOrderList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ActiveOrderContainerView());

    default:
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              AppLoadingView());
  }
}
