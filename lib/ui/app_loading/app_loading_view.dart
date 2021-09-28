import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_colors.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_config.dart';
import 'package:flutterrtdeliveryboyapp/constant/ps_constants.dart';
import 'package:flutterrtdeliveryboyapp/provider/clear_all/clear_all_data_provider.dart';
import 'package:flutterrtdeliveryboyapp/repository/clear_all_data_repository.dart';
import 'package:flutterrtdeliveryboyapp/ui/common/dialog/version_update_dialog.dart';
import 'package:flutterrtdeliveryboyapp/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/common/ps_square_progress_widget.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_value_holder.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/holder/app_info_parameter_holder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_resource.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
import 'package:flutterrtdeliveryboyapp/constant/ps_dimens.dart';
import 'package:flutterrtdeliveryboyapp/constant/route_paths.dart';
import 'package:flutterrtdeliveryboyapp/provider/app_info/app_info_provider.dart';
import 'package:flutterrtdeliveryboyapp/repository/app_info_repository.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/ps_app_info.dart';
import 'package:provider/single_child_widget.dart';

class AppLoadingView extends StatelessWidget {
  Future<dynamic> loadDeleteHistory(AppInfoProvider provider,
      ClearAllDataProvider clearAllDataProvider, BuildContext context) async {
    String realStartDate = '0';
    String realEndDate = '0';
    if (await Utils.checkInternetConnectivity()) {
      if (provider.psValueHolder == null ||
          provider.psValueHolder.startDate == null) {
        realStartDate =
            DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
      } else {
        realStartDate = provider.psValueHolder.endDate;
      }

      realEndDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
      final AppInfoParameterHolder appInfoParameterHolder =
          AppInfoParameterHolder(
              startDate: realStartDate,
              endDate: realEndDate,
              userId: Utils.checkUserLoginId(provider.psValueHolder));

      final PsResource<PSAppInfo> _psAppInfo =
          await provider.loadDeleteHistory(appInfoParameterHolder.toMap());

      if (_psAppInfo.status == PsStatus.SUCCESS) {
       await provider.replaceDate(realStartDate, realEndDate);
        print(Utils.getString(context, 'app_info__cancel_button_name'));
        print(Utils.getString(context, 'app_info__update_button_name'));

        if(_psAppInfo.data.userInfo.userStatus == PsConst.USER_BANNED ){
          callLogout(provider,
          // deleteTaskProvider,
          PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,context);
          showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              message: Utils.getString(context,
                      'user_status__banned'),
              onPressed: (){
                checkVersionNumber(
                context, _psAppInfo.data, provider, clearAllDataProvider);
                realStartDate = realEndDate;
              },
            );
          });
        }else if(_psAppInfo.data.userInfo.userStatus == PsConst.USER_DELECTED){
          callLogout(provider,
          // deleteTaskProvider,
          PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,context);
          showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              message: Utils.getString(context,
                      'user_status__deleted'),
              onPressed: (){
                checkVersionNumber(
                context, _psAppInfo.data, provider, clearAllDataProvider);
                realStartDate = realEndDate;
              },
            );
          });
        }else if(_psAppInfo.data.userInfo.userStatus == PsConst.USER_UN_PUBLISHED){
          callLogout(provider,
          // deleteTaskProvider,
          PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,context);
          showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              message: Utils.getString(context,
                      'user_status__unpublished'),
              onPressed: (){
                checkVersionNumber(
                context, _psAppInfo.data, provider, clearAllDataProvider);
                realStartDate = realEndDate;
              },
            );
          });
        }else{
          checkVersionNumber(
                context, _psAppInfo.data, provider, clearAllDataProvider);
                realStartDate = realEndDate;
          
        }
        
      } else if (_psAppInfo.status == PsStatus.ERROR) {
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.shopDashboard,
        );
      }
    } else {
      Navigator.pushReplacementNamed(
        context,
        RoutePaths.shopDashboard,
      );
    }
  }

  dynamic callLogout(
      AppInfoProvider appInfoProvider, int index, BuildContext context) async {
    // updateSelectedIndex( index);
   await appInfoProvider.replaceLoginUserId('');
   await appInfoProvider.replaceLoginUserName('');
    // await deleteTaskProvider.deleteTask();
    await FacebookLogin().logOut();
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  final Widget _imageWidget = Container(
    width: 90,
    height: 90,
    child: Image.asset(
      'assets/images/app_icon.png',
    ),
  );

  dynamic checkVersionNumber(
      BuildContext context,
      PSAppInfo psAppInfo,
      AppInfoProvider appInfoProvider,
      ClearAllDataProvider clearAllDataProvider) async {
    if (PsConfig.app_version != psAppInfo.deliBoyVersion.deliBoyVersionNo) {
      if (psAppInfo.deliBoyVersion.deliBoyVersionNeedClearData == PsConst.ONE) {
        // final PsResource<List<Product>> _apiStatus =
        await clearAllDataProvider.clearAllData();
        // print(_apiStatus.status);
        // if (_apiStatus.status == PsStatus.SUCCESS) {
        checkForceUpdate(context, psAppInfo, appInfoProvider);
        // }
      } else {
        checkForceUpdate(context, psAppInfo, appInfoProvider);
      }
    } else {
     await appInfoProvider.replaceVersionForceUpdateData(false);
      //
      Navigator.pushReplacementNamed(
        context,
        RoutePaths.shopDashboard,
      );
    }
  }

  dynamic checkForceUpdate(BuildContext context, PSAppInfo psAppInfo,
      AppInfoProvider appInfoProvider) async {
    if (psAppInfo.deliBoyVersion.deliBoyVersionForceUpdate == PsConst.ONE) {
     await appInfoProvider.replaceAppInfoData(
          psAppInfo.deliBoyVersion.deliBoyVersionNo,
          true,
          psAppInfo.deliBoyVersion.deliBoyVersionTitle,
          psAppInfo.deliBoyVersion.deliBoyVersionMessage);

      Navigator.pushReplacementNamed(
        context,
        RoutePaths.force_update,
        arguments: psAppInfo.deliBoyVersion,
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        RoutePaths.shopDashboard,
      );
    }
  }

  dynamic callVersionUpdateDialog(BuildContext context, PSAppInfo psAppInfo) {
    showDialog<dynamic>(
        barrierDismissible: false,
        useRootNavigator: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () {
                return;
              },
              child: VersionUpdateDialog(
                title: psAppInfo.deliBoyVersion.deliBoyVersionTitle,
                description: psAppInfo.deliBoyVersion.deliBoyVersionMessage,
                // leftButtonText: AppLocalizations.of(context)
                //     .tr('app_info__cancel_button_name'),
                leftButtonText:
                    Utils.getString(context, 'app_info__cancel_button_name'),
                rightButtonText:
                    Utils.getString(context, 'app_info__update_button_name'),
                onCancelTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    RoutePaths.shopDashboard,
                  );
                },
                onUpdateTap: () async {
                  Navigator.pushReplacementNamed(
                    context,
                    RoutePaths.shopDashboard,
                  );

                  if (Platform.isIOS) {
                    Utils.launchAppStoreURL(iOSAppId: PsConfig.iOSAppStoreId);
                  } else if (Platform.isAndroid) {
                    Utils.launchURL();
                  }
                },
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    AppInfoRepository repo1;
    AppInfoProvider provider;
    ClearAllDataRepository clearAllDataRepository;
    ClearAllDataProvider clearAllDataProvider;
    PsValueHolder valueHolder;

    PsColors.loadColor(context);
    // valueHolder = Provider.of<PsValueHolder>(context);
    repo1 = Provider.of<AppInfoRepository>(context);
    clearAllDataRepository = Provider.of<ClearAllDataRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    if (valueHolder == null) {
      return Container();
    }

    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<ClearAllDataProvider>(
            lazy: false,
            create: (BuildContext context) {
              // valueHolder ??= Provider.of<PsValueHolder>(context);
              clearAllDataProvider = ClearAllDataProvider(
                  repo: clearAllDataRepository, psValueHolder: valueHolder);

              return clearAllDataProvider;
            }),
        ChangeNotifierProvider<AppInfoProvider>(
            lazy: false,
            create: (BuildContext context) {
              provider =
                  AppInfoProvider(repo: repo1, psValueHolder: valueHolder);
              loadDeleteHistory(provider, clearAllDataProvider, context);
              return provider;
            }),
      ],
      child: Consumer<AppInfoProvider>(
        builder: (BuildContext context, AppInfoProvider clearAllDataProvider,
            Widget child) {
          return Container(
              height: 400,
             decoration: BoxDecoration(
               gradient: LinearGradient(colors: <Color>[
                 PsColors.mainColor,
                 PsColors.mainDarkColor,
               ]),
             ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _imageWidget,
                      const SizedBox(
                        height: PsDimens.space16,
                      ),
                      Text(
                        Utils.getString(context, 'app_name'),
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.bold,
                            color: PsColors.white),
                      ),
                      const SizedBox(
                        height: PsDimens.space8,
                      ),
                      Text(
                        Utils.getString(context, 'app_info__splash_name'),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: PsColors.white),
                      ),
                      Container(
                        padding: const EdgeInsets.all(PsDimens.space16),
                        child: PsSquareProgressWidget()
                      ),
                    ],
                  )
                ],
              ));
        },
      ),
    );
  }
}

class PsButtonWidget extends StatefulWidget {
  const PsButtonWidget({
    @required this.provider,
    @required this.text,
  });
  final AppInfoProvider provider;
  final String text;

  @override
  _PsButtonWidgetState createState() => _PsButtonWidgetState();
}

class _PsButtonWidgetState extends State<PsButtonWidget> {
  @override
  Widget build(BuildContext context) {
    // return CircularProgressIndicator(
    //     valueColor: AlwaysStoppedAnimation<Color>(PsColors.loadingCircleColor),
    //     strokeWidth: 5.0);
    return PsSquareProgressWidget();
  }
}
