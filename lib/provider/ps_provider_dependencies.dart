import 'package:flutterrtdeliveryboyapp/db/about_app_dao.dart';
import 'package:flutterrtdeliveryboyapp/db/about_us_dao.dart';
import 'package:flutterrtdeliveryboyapp/db/point_dao.dart';
import 'package:flutterrtdeliveryboyapp/db/transaction_map_dao.dart';
import 'package:flutterrtdeliveryboyapp/db/transaction_status_dao.dart';
import 'package:flutterrtdeliveryboyapp/repository/about_app_repository.dart';
import 'package:flutterrtdeliveryboyapp/repository/about_us_repository.dart';
import 'package:flutterrtdeliveryboyapp/repository/delete_task_repository.dart';
import 'package:flutterrtdeliveryboyapp/db/gallery_dao.dart';
import 'package:flutterrtdeliveryboyapp/db/user_dao.dart';
import 'package:flutterrtdeliveryboyapp/db/user_login_dao.dart';
import 'package:flutterrtdeliveryboyapp/repository/Common/notification_repository.dart';
import 'package:flutterrtdeliveryboyapp/repository/clear_all_data_repository.dart';
import 'package:flutterrtdeliveryboyapp/repository/contact_us_repository.dart';
import 'package:flutterrtdeliveryboyapp/db/shop_info_dao.dart';
import 'package:flutterrtdeliveryboyapp/db/transaction_detail_dao.dart';
import 'package:flutterrtdeliveryboyapp/db/transaction_header_dao.dart';
import 'package:flutterrtdeliveryboyapp/repository/gallery_repository.dart';
import 'package:flutterrtdeliveryboyapp/repository/payment_status_repository.dart';
import 'package:flutterrtdeliveryboyapp/repository/point_repository.dart';
import 'package:flutterrtdeliveryboyapp/repository/shop_repository.dart';
import 'package:flutterrtdeliveryboyapp/repository/shop_info_repository.dart';
import 'package:flutterrtdeliveryboyapp/repository/tansaction_detail_repository.dart';
import 'package:flutterrtdeliveryboyapp/repository/token_repository.dart';
import 'package:flutterrtdeliveryboyapp/repository/transaction_header_repository.dart';
import 'package:flutterrtdeliveryboyapp/repository/transaction_status_repository.dart';
import 'package:flutterrtdeliveryboyapp/repository/user_repository.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterrtdeliveryboyapp/api/ps_api_service.dart';
import 'package:flutterrtdeliveryboyapp/db/common/ps_shared_preferences.dart';
import 'package:flutterrtdeliveryboyapp/db/noti_dao.dart';
import 'package:flutterrtdeliveryboyapp/db/shop_dao.dart';
import 'package:flutterrtdeliveryboyapp/repository/app_info_repository.dart';
import 'package:flutterrtdeliveryboyapp/repository/language_repository.dart';
import 'package:flutterrtdeliveryboyapp/repository/noti_repository.dart';
import 'package:flutterrtdeliveryboyapp/repository/ps_theme_repository.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = <SingleChildWidget>[
  ...independentProviders,
  ..._dependentProviders,
  ..._valueProviders,
];

List<SingleChildWidget> independentProviders = <SingleChildWidget>[
  Provider<PsSharedPreferences>.value(value: PsSharedPreferences.instance),
  Provider<PsApiService>.value(value: PsApiService()),
  Provider<AboutUsDao>.value(value: AboutUsDao.instance),
  Provider<NotiDao>.value(value: NotiDao.instance),
  Provider<ShopInfoDao>.value(value: ShopInfoDao.instance),
  Provider<TransactionMapDao>.value(value: TransactionMapDao.instance),
  Provider<TransactionHeaderDao>.value(value: TransactionHeaderDao.instance),
  Provider<TransactionDetailDao>.value(value: TransactionDetailDao.instance),
  Provider<UserDao>.value(value: UserDao.instance),
  Provider<UserLoginDao>.value(value: UserLoginDao.instance),
  Provider<GalleryDao>.value(value: GalleryDao.instance),
  Provider<ShopDao>.value(value: ShopDao.instance),
  Provider<PointDao>.value(value: PointDao.instance),
  Provider<AboutAppDao>.value(value: AboutAppDao.instance),
  Provider<TransactionStatusDao>.value(value: TransactionStatusDao.instance),
];

List<SingleChildWidget> _dependentProviders = <SingleChildWidget>[
  ProxyProvider<PsSharedPreferences, PsThemeRepository>(
    update: (_, PsSharedPreferences ssSharedPreferences,
            PsThemeRepository psThemeRepository) =>
        PsThemeRepository(psSharedPreferences: ssSharedPreferences),
  ),
  ProxyProvider<PsApiService, AppInfoRepository>(
    update:
        (_, PsApiService psApiService, AppInfoRepository appInfoRepository) =>
            AppInfoRepository(psApiService: psApiService),
  ),
  ProxyProvider<PsSharedPreferences, LanguageRepository>(
    update: (_, PsSharedPreferences ssSharedPreferences,
            LanguageRepository languageRepository) =>
        LanguageRepository(psSharedPreferences: ssSharedPreferences),
  ),
  ProxyProvider<PsApiService, TokenRepository>(
    update: (_, PsApiService psApiService, TokenRepository tokenRepository) =>
        TokenRepository(psApiService: psApiService),
  ),
  ProxyProvider<PsApiService, NotificationRepository>(
    update:
        (_, PsApiService psApiService, NotificationRepository userRepository) =>
            NotificationRepository(
      psApiService: psApiService,
    ),
  ),
  ProxyProvider2<PsApiService, GalleryDao, GalleryRepository>(
    update: (_, PsApiService psApiService, GalleryDao galleryDao,
            GalleryRepository galleryRepository) =>
        GalleryRepository(galleryDao: galleryDao, psApiService: psApiService),
  ),
  ProxyProvider3<PsApiService, UserDao, UserLoginDao, UserRepository>(
    update: (_, PsApiService psApiService, UserDao userDao,
            UserLoginDao userLoginDao, UserRepository userRepository) =>
        UserRepository(
            psApiService: psApiService,
            userDao: userDao,
            userLoginDao: userLoginDao),
  ),
  ProxyProvider<PsApiService, ClearAllDataRepository>(
    update: (_, PsApiService psApiService,
            ClearAllDataRepository clearAllDataRepository) =>
        ClearAllDataRepository(),
  ),
  ProxyProvider<PsApiService, DeleteTaskRepository>(
    update: (_, PsApiService psApiService,
            DeleteTaskRepository deleteTaskRepository) =>
        DeleteTaskRepository(),
  ),
  ProxyProvider<PsApiService, ContactUsRepository>(
    update: (_, PsApiService psApiService,
            ContactUsRepository apiStatusRepository) =>
        ContactUsRepository(psApiService: psApiService),
  ),
  ProxyProvider2<PsApiService, AboutAppDao, AboutAppRepository>(
    update: (_, PsApiService psApiService, AboutAppDao aboutUsDao,
            AboutAppRepository aboutUsRepository) =>
        AboutAppRepository(psApiService: psApiService, aboutUsDao: aboutUsDao),
  ),
  ProxyProvider<PsApiService, PaymentStatusRepository>(
    update: (_, PsApiService psApiService,
            PaymentStatusRepository apiStatusRepository) =>
        PaymentStatusRepository(psApiService: psApiService),
  ),
  ProxyProvider2<PsApiService, AboutUsDao, AboutUsRepository>(
    update: (_, PsApiService psApiService, AboutUsDao aboutUsDao,
            AboutUsRepository aboutUsRepository) =>
        AboutUsRepository(psApiService: psApiService, aboutUsDao: aboutUsDao),
  ),
  ProxyProvider2<PsApiService, NotiDao, NotiRepository>(
    update: (_, PsApiService psApiService, NotiDao notiDao,
            NotiRepository notiRepository) =>
        NotiRepository(psApiService: psApiService, notiDao: notiDao),
  ),
  ProxyProvider2<PsApiService, ShopInfoDao, ShopInfoRepository>(
    update: (_, PsApiService psApiService, ShopInfoDao shopInfoDao,
            ShopInfoRepository shopInfoRepository) =>
        ShopInfoRepository(
            psApiService: psApiService, shopInfoDao: shopInfoDao),
  ),
  ProxyProvider2<PsApiService, PointDao, PointRepository>(
    update: (_, PsApiService psApiService, PointDao pointDao,
            PointRepository shopInfoRepository) =>
        PointRepository(psApiService: psApiService, pointDao: pointDao),
  ),
  ProxyProvider2<PsApiService, TransactionHeaderDao,
      TransactionHeaderRepository>(
    update: (_,
            PsApiService psApiService,
            TransactionHeaderDao transactionHeaderDao,
            TransactionHeaderRepository transactionRepository) =>
        TransactionHeaderRepository(
            psApiService: psApiService,
            transactionHeaderDao: transactionHeaderDao),
  ),
  ProxyProvider2<PsApiService, TransactionDetailDao,
      TransactionDetailRepository>(
    update: (_,
            PsApiService psApiService,
            TransactionDetailDao transactionDetailDao,
            TransactionDetailRepository transactionDetailRepository) =>
        TransactionDetailRepository(
            psApiService: psApiService,
            transactionDetailDao: transactionDetailDao),
  ),
  ProxyProvider2<PsApiService, TransactionStatusDao,
      TransactionStatusRepository>(
    update: (_,
            PsApiService psApiService,
            TransactionStatusDao transactionStatusDao,
            TransactionStatusRepository transactionStatusRepository) =>
        TransactionStatusRepository(
            psApiService: psApiService,
            transactionStatusDao: transactionStatusDao),
  ),
  ProxyProvider2<PsApiService, ShopDao, ShopRepository>(
    update: (_, PsApiService psApiService, ShopDao shopDao,
            ShopRepository shopRepository) =>
        ShopRepository(psApiService: psApiService, shopDao: shopDao),
  ),
];
List<SingleChildWidget> _valueProviders = <SingleChildWidget>[
  StreamProvider<PsValueHolder>(
    create: (BuildContext context) =>
        Provider.of<PsSharedPreferences>(context, listen: false).psValueHolder,
  )
];
