import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_colors.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutterrtdeliveryboyapp/provider/common/main_dashboard_provider.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/common/language.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_theme_data.dart';
import 'package:flutterrtdeliveryboyapp/provider/common/ps_theme_provider.dart';
import 'package:flutterrtdeliveryboyapp/provider/ps_provider_dependencies.dart';
import 'package:flutterrtdeliveryboyapp/repository/ps_theme_repository.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutterrtdeliveryboyapp/config/router.dart' as router;
import 'config/ps_config.dart';
import 'constant/ps_constants.dart';
import 'db/common/ps_shared_preferences.dart';

Future<void> main() async {
  // add this, and it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseMessaging _fcm = FirebaseMessaging();
  if (Platform.isIOS) {
    _fcm.requestNotificationPermissions(const IosNotificationSettings());
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getString('codeC') == null) {
    await prefs.setString('codeC', null);
    await prefs.setString('codeL', null);
  }

  Firebase.initializeApp();
  NativeAdmob(adUnitID: Utils.getAdAppId());
  
  //check is apple signin is available
  await Utils.checkAppleSignInAvailable();

  Utils.psPrint('Apple Sign Flag is : ${Utils.isAppleSignInAvailable}');

  runApp(EasyLocalization(
      path: 'assets/langs',
      startLocale: PsConfig.defaultLanguage.toLocale(),
      supportedLocales: getSupportedLanguages(),
      child: PSApp()));
}

List<Locale> getSupportedLanguages() {
  final List<Locale> localeList = <Locale>[];
  for (final Language lang in PsConfig.psSupportedLanguageList) {
    localeList.add(Locale(lang.languageCode, lang.countryCode));
  }
  print('Loaded Languages');
  return localeList;
}

Future<dynamic> initAds() async {
  if (PsConst.SHOW_ADMOB && await Utils.checkInternetConnectivity()) {
    // FirebaseAdMob.instance.initialize(appId: utilsGetAdAppId());
  }
}

class PSApp extends StatefulWidget {
  @override
  _PSAppState createState() => _PSAppState();
}

class _PSAppState extends State<PSApp> {
  Completer<ThemeData> themeDataCompleter;
  PsSharedPreferences psSharedPreferences;

  @override
  void initState() {
    super.initState();
  }

  Future<ThemeData> getSharePerference(
      EasyLocalization provider, dynamic data) {
    Utils.psPrint('>> get share perference');
    if (themeDataCompleter == null) {
      Utils.psPrint('init completer');
      themeDataCompleter = Completer<ThemeData>();
    }

    if (psSharedPreferences == null) {
      Utils.psPrint('init ps shareperferences');
      psSharedPreferences = PsSharedPreferences.instance;
      Utils.psPrint('get shared');

      psSharedPreferences.futureShared.then((SharedPreferences sh) {
        psSharedPreferences.shared = sh;

        Utils.psPrint('init theme provider');
        final PsThemeProvider psThemeProvider = PsThemeProvider(
            repo: PsThemeRepository(psSharedPreferences: psSharedPreferences));

        Utils.psPrint('get theme');
        final ThemeData themeData = psThemeProvider.getTheme();

        themeDataCompleter.complete(themeData);
        Utils.psPrint('themedata loading completed');
      });
    }

    return themeDataCompleter.future;
  }

  List<Locale> getSupportedLanguages() {
    final List<Locale> localeList = <Locale>[];
    for (final Language lang in PsConfig.psSupportedLanguageList) {
      localeList.add(Locale(lang.languageCode, lang.countryCode));
    }
    print('Loaded Languages');
    return localeList;
  }

  @override
  Widget build(BuildContext context) {
    // init Color
    PsColors.loadColor(context);
    return MultiProvider(
        providers: <SingleChildWidget>[
          ...providers,
          ChangeNotifierProvider<MainDashboardProvider>(
              lazy: false,
              create: (BuildContext context) {
                return MainDashboardProvider(
                    PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
                    Utils.getString(context, 'app_name'));
              }),
        ],
        child: DynamicTheme(
            defaultBrightness: Brightness.light,
            data: (Brightness brightness) {
              if (brightness == Brightness.light) {
                return themeData(ThemeData.light());
              } else {
                return themeData(ThemeData.dark());
              }
            },
            themedWidgetBuilder: (BuildContext context, ThemeData theme) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'SaviansDish Drivers',
                theme: theme,
                initialRoute: '/',
                onGenerateRoute: router.generateRoute,
                localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  EasyLocalization.of(context).delegate,
                ],
                supportedLocales: EasyLocalization.of(context).supportedLocales,
                locale: EasyLocalization.of(context).locale,
              );
            }));
  }
}
