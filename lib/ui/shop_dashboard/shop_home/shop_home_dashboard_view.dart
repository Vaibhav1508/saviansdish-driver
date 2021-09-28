import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_colors.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_config.dart';
import 'package:flutterrtdeliveryboyapp/constant/ps_constants.dart';
import 'package:flutterrtdeliveryboyapp/provider/app_info/app_info_provider.dart';
import 'package:flutterrtdeliveryboyapp/provider/common/main_dashboard_provider.dart';
import 'package:flutterrtdeliveryboyapp/provider/shop_info/shop_info_provider.dart';
import 'package:flutterrtdeliveryboyapp/provider/transaction/completed_order_provider.dart';
import 'package:flutterrtdeliveryboyapp/provider/transaction/pending_order_provider.dart';
import 'package:flutterrtdeliveryboyapp/provider/user/user_provider.dart';
import 'package:flutterrtdeliveryboyapp/repository/shop_info_repository.dart';
import 'package:flutterrtdeliveryboyapp/repository/transaction_header_repository.dart';
import 'package:flutterrtdeliveryboyapp/repository/user_repository.dart';
import 'package:flutterrtdeliveryboyapp/ui/common/ps_ui_widget.dart';
import 'package:flutterrtdeliveryboyapp/ui/map/current_location_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/order/item/order_list_item.dart';
import 'package:flutterrtdeliveryboyapp/ui/order/item/pending_order_list_item.dart';
import 'package:flutterrtdeliveryboyapp/ui/user/login/login_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/user/pending_user/pending_user_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/user/reject_user/reject_user_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/user/verify/verify_email_view.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_value_holder.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/holder/completed_order_list_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/holder/pending_order_list_holder.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_parameter_holder.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutterrtdeliveryboyapp/constant/ps_dimens.dart';
import 'package:flutterrtdeliveryboyapp/constant/route_paths.dart';

class ShopHomeDashboardViewWidget extends StatefulWidget {
  const ShopHomeDashboardViewWidget({
    this.animationController,
  });
  final AnimationController animationController;

  @override
  _ShopHomeDashboardViewWidgetState createState() =>
      _ShopHomeDashboardViewWidgetState();
}

class _ShopHomeDashboardViewWidgetState
    extends State<ShopHomeDashboardViewWidget> {
  PsValueHolder psValueHolder;
  ShopInfoRepository shopInfoRepository;

  CompletedOrderProvider completedOrderProvider;
  PendingOrderProvider pendingOrderProvider;
  TransactionHeaderRepository transactionHeaderRepository;
  UserRepository userRepository;
  ShopInfoProvider shopInfoProvider;
  MainDashboardProvider mainDashboardProvider;

  CompletedOrderListHolder completedOrderListHolder;
  PendingOrderListHolder pendingOrderListHolder;
  TextEditingController addressController = TextEditingController();
  AppInfoProvider appInfoProvider;

  final int count = 8;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> updateTitle(MainDashboardProvider provider, String title) async {
    provider.updateIndex(provider.currentIndex, title, mounted);
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation =
        Utils.getTweenAnimation(widget.animationController, 1);

    shopInfoRepository = Provider.of<ShopInfoRepository>(context);
    transactionHeaderRepository =
        Provider.of<TransactionHeaderRepository>(context);
    userRepository = Provider.of<UserRepository>(context);

    mainDashboardProvider =
        Provider.of<MainDashboardProvider>(context, listen: false);

    psValueHolder = Provider.of<PsValueHolder>(context);

    Utils.psPrint(psValueHolder.loginUserId);
    Utils.psPrint(psValueHolder.isDeliveryBoy);
    widget.animationController.forward();

    // Is user to login
    if (psValueHolder.isUserToLogin()) {
      updateTitle(
          mainDashboardProvider, Utils.getString(context, 'login__title'));
      return LoginView(
        animationController: widget.animationController,
        animation: animation,
        callback: () {
          mainDashboardProvider.updateIndex(
              PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
              Utils.getString(context, 'app_name'),
              mounted);
        },
      );
    }
    // Is user to verify
    else if (psValueHolder.isUserToVerfity()) {
      updateTitle(mainDashboardProvider,
          Utils.getString(context, 'email_verify__title'));
      return VerifyEmailView(
        animationController: widget.animationController,
        callback: () {
          mainDashboardProvider.updateIndex(
              PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
              Utils.getString(context, 'app_name'),
              mounted);
        },
        // userId: psValueHolder.loginUserId,
      );
    }

    // Is user delivery boy status is pending
    else if (psValueHolder.isDeliveryBoy == PsConst.PENDING_STATUS) {
      updateTitle(mainDashboardProvider,
          Utils.getString(context, 'user__wait_approve_title'));
      return const PendingUserView();
    }
    // Is user delivery boy status is rejected
    else if (psValueHolder.isDeliveryBoy == PsConst.REJECT_STATUS) {
      updateTitle(mainDashboardProvider,
          Utils.getString(context, 'user__reject_title'));
      return const RejectUserView();
    }

    
    updateTitle(mainDashboardProvider, Utils.getString(context, 'app_name'));
      return Scaffold(
        key: scaffoldKey,
        body: MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<CompletedOrderProvider>(
              lazy: false,
              create: (BuildContext context) {
                completedOrderProvider =
                    CompletedOrderProvider(repo: transactionHeaderRepository);
                completedOrderListHolder = CompletedOrderListHolder(
                    deliveryBoyId: Utils.checkUserLoginId(psValueHolder));
                completedOrderProvider.loadCompletedOrderList(
                    completedOrderListHolder.toMap(),
                    TransactionParameterHolder()
                        .getCompletedOrderParameterHolder());
                return completedOrderProvider;
              }),
          ChangeNotifierProvider<PendingOrderProvider>(
              lazy: false,
              create: (BuildContext context) {
                pendingOrderProvider =
                    PendingOrderProvider(repo: transactionHeaderRepository);
                pendingOrderListHolder = PendingOrderListHolder(
                    deliveryBoyId: Utils.checkUserLoginId(psValueHolder));
                pendingOrderProvider.loadPendingOrderList(
                    pendingOrderListHolder.toMap(),
                    TransactionParameterHolder()
                        .getPendingOrderParameterHolder());
                return pendingOrderProvider;
              }),
          ChangeNotifierProvider<ShopInfoProvider>(
                lazy: false,
                create: (BuildContext context) {
                  shopInfoProvider = ShopInfoProvider(
                      repo: shopInfoRepository,
                      ownerCode: 'ShopDashboardView',
                      psValueHolder: psValueHolder);
                    if (PsConfig.isMultiRestaurant) {
                    shopInfoProvider
                        .loadShopInfoById(shopInfoProvider.psValueHolder.shopId);
                    }else{
                      shopInfoProvider.loadShopInfo();
                    }
                  return shopInfoProvider;
          }),
          ChangeNotifierProvider<UserProvider>(
              lazy: false,
              create: (BuildContext context) {
                final UserProvider userProvider = UserProvider(
                    repo: userRepository, psValueHolder: psValueHolder);

                userProvider.getUser(psValueHolder.loginUserId);

                return userProvider;
              }),
        ],
        child: Container(
          color: PsColors.coreBackgroundColor,
          child: RefreshIndicator(
            onRefresh: () {
              pendingOrderProvider.resetPendingOrderList(
                  pendingOrderListHolder.toMap(),
                  TransactionParameterHolder()
                      .getPendingOrderParameterHolder());
              return completedOrderProvider.resetCompletedOrderList(
                  completedOrderListHolder.toMap(),
                  TransactionParameterHolder()
                      .getCompletedOrderParameterHolder());
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: CurrentLocationWidget(
                    androidFusedLocation: true,
                    textEditingController: addressController,
                    isShowAddress: true,
                    shopInfoProvider: shopInfoProvider,
                )),
                _PendingOrderListWidget(
                  provider: pendingOrderProvider,
                  completedOrderProvider: completedOrderProvider,
                  animationController: widget.animationController,
                  scaffoldKey: scaffoldKey,
                  pendingOrderListHolder: pendingOrderListHolder,
                ),
                _OrderAndSeeAllWidget(
                    animationController: widget.animationController,
                    completedOrderProvider: completedOrderProvider),
                _TransactionListViewWidget(
                  scaffoldKey: scaffoldKey,
                  animationController: widget.animationController,
                  provider: completedOrderProvider,
                  completedOrderListHolder: completedOrderListHolder,
                  pendingOrderProvider: pendingOrderProvider,
                ),
              ],
            ),
          ),
        )),
      );
  }
}

class _PendingOrderListWidget extends StatelessWidget {
  const _PendingOrderListWidget(
      {this.provider,
      this.animationController,
      this.scaffoldKey,
      this.pendingOrderListHolder,
      this.completedOrderProvider});
  final PendingOrderProvider provider;
  final AnimationController animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final PendingOrderListHolder pendingOrderListHolder;
  final CompletedOrderProvider completedOrderProvider;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<PendingOrderProvider>(builder:
        (BuildContext context, PendingOrderProvider provider, Widget child) {
      // animationController.forward();
      final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
          .animate(CurvedAnimation(
              parent: animationController,
              curve:
                  const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
      if (provider.pendingTransactionList != null &&
          provider.pendingTransactionList.data != null) {
        if (provider.pendingTransactionList.data.isEmpty) {
          return AnimatedBuilder(
            animation: animationController,
            child: Stack(children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.only(top: PsDimens.space120),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/empty_active_delivery.png',
                        height: 100,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      Utils.getString(
                          context, 'order_list__empty_title'),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(),
                    ),
                    const SizedBox(
                      height: PsDimens.space8,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          PsDimens.space72, 0, PsDimens.space72, 0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            Utils.getString(
                                context, 'order_list__empty_desc'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    Visibility(
                      visible: PsStatus.SUCCESS ==
                              provider
                                  .pendingTransactionList.status ||
                          PsStatus.ERROR ==
                              provider.pendingTransactionList.status,
                      child: InkWell(
                        child: Container(
                          height: PsDimens.space80,
                          width: PsDimens.space80,
                          child: Icon(
                            Icons.refresh,
                            color: PsColors.mainColor,
                            size: PsDimens.space40,
                          ),
                        ),
                        onTap: () {
                          final PsValueHolder psValueHolder =
                              Provider.of<PsValueHolder>(context,
                                  listen: false);
                          final PendingOrderListHolder
                              pendingOrderListHolder =
                              PendingOrderListHolder(
                                  deliveryBoyId:
                                      Utils.checkUserLoginId(
                                          psValueHolder));
                          return provider.resetPendingOrderList(
                              pendingOrderListHolder.toMap(),
                              TransactionParameterHolder()
                                  .getPendingOrderParameterHolder());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  PSProgressIndicator(
                      provider.pendingTransactionList.status),
                ]
              ),
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                  opacity: animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - animation.value), 0.0),
              child: child
              ));
            },
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: PsDimens.space16),
            child: Stack(children: <Widget>[
              Container(
                  child: RefreshIndicator(
                child: CustomScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            if (provider.pendingTransactionList.data != null ||
                                provider
                                    .pendingTransactionList.data.isNotEmpty) {
                              final int count =
                                  provider.pendingTransactionList.data.length;
                              return PendingOrderListItem(
                                scaffoldKey: scaffoldKey,
                                animationController: animationController,
                                animation:
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animationController,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                ),
                                transaction:
                                    provider.pendingTransactionList.data[index],
                                onTap: () async {
                                  final dynamic returnData =
                                      await Navigator.pushNamed(
                                          context, RoutePaths.transactionDetail,
                                          arguments: provider
                                              .pendingTransactionList
                                              .data[index]);
                                  if (returnData) {
                                    final PsValueHolder psValueHolder =
                                        Provider.of<PsValueHolder>(context,
                                            listen: false);
                                    final PendingOrderListHolder
                                        pendingOrderListHolder =
                                        PendingOrderListHolder(
                                            deliveryBoyId:
                                                Utils.checkUserLoginId(
                                                    psValueHolder));
                                    provider.loadPendingOrderList(
                                        pendingOrderListHolder.toMap(),
                                        TransactionParameterHolder()
                                            .getPendingOrderParameterHolder());
                                    //
                                    completedOrderProvider.loadCompletedOrderList(
                                        pendingOrderListHolder.toMap(),
                                        TransactionParameterHolder()
                                            .getCompletedOrderParameterHolder());
                                  }
                                },
                              );
                            } else {
                              return null;
                            }
                          },
                          childCount:
                              provider.pendingTransactionList.data.length,
                        ),
                      ),
                    ]),
                onRefresh: () {
                  return provider.resetPendingOrderList(
                      pendingOrderListHolder.toMap(),
                      TransactionParameterHolder()
                          .getPendingOrderParameterHolder());
                },
              )),
            ]),
          );
        }
      } else {
        return Container();
      }
    }));
  }
}

class _OrderAndSeeAllWidget extends StatefulWidget {
  const _OrderAndSeeAllWidget(
      {@required this.animationController,
      @required this.completedOrderProvider});
  final AnimationController animationController;
  final CompletedOrderProvider completedOrderProvider;
  @override
  __OrderAndSeeAllWidgetState createState() => __OrderAndSeeAllWidgetState();
}

class __OrderAndSeeAllWidgetState extends State<_OrderAndSeeAllWidget> {
  @override
  Widget build(BuildContext context) {
    // widget.animationController.forward();
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: widget.animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    return SliverToBoxAdapter(child: Consumer<CompletedOrderProvider>(builder:
        (BuildContext context, CompletedOrderProvider provider, Widget child) {
      if (provider.completedTransactionList != null &&
          provider.completedTransactionList.data != null &&
          provider.completedTransactionList.data.isNotEmpty) {
        return AnimatedBuilder(
          animation: widget.animationController,
          child: Column(
            children: <Widget>[
              const Divider(
                height: PsDimens.space1,
              ),
              const SizedBox(height: PsDimens.space24),
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutePaths.completedTransactionList,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space16,
                        right: PsDimens.space16,
                        bottom: PsDimens.space16),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                            Utils.getString(
                                context, 'profile__order'),
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(color: PsColors.mainColor)),
                        InkWell(
                          child: Text(
                            Utils.getString(
                                context, 'profile__view_all'),
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                opacity: animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
              child: child
              )
            );
          },
        );
      } else {
        return Container();
      }
    }));
  }
}

class _TransactionListViewWidget extends StatelessWidget {
  const _TransactionListViewWidget(
      {Key key,
      @required this.animationController,
      @required this.provider,
      @required this.scaffoldKey,
      @required this.completedOrderListHolder,
      @required this.pendingOrderProvider})
      : super(key: key);

  final AnimationController animationController;
  final CompletedOrderProvider provider;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final CompletedOrderListHolder completedOrderListHolder;
  final PendingOrderProvider pendingOrderProvider;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<CompletedOrderProvider>(builder:
        (BuildContext context, CompletedOrderProvider provider, Widget child) {
      if (provider.completedTransactionList != null &&
          provider.completedTransactionList.data != null) {
        return Padding(
          padding: const EdgeInsets.only(bottom: PsDimens.space44),
          child: Stack(children: <Widget>[
            Container(
                child: RefreshIndicator(
              child: CustomScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (provider.completedTransactionList.data != null ||
                              provider
                                  .completedTransactionList.data.isNotEmpty) {
                            final int count =
                                provider.completedTransactionList.data.length;
                            return OrderListItem(
                              scaffoldKey: scaffoldKey,
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              transaction:
                                  provider.completedTransactionList.data[index],
                              onTap: () async {
                                final dynamic returnData =
                                    await Navigator.pushNamed(
                                        context, RoutePaths.transactionDetail,
                                        arguments: provider
                                            .completedTransactionList
                                            .data[index]);
                                if (returnData) {
                                  final PsValueHolder psValueHolder =
                                      Provider.of<PsValueHolder>(context,
                                          listen: false);
                                  final CompletedOrderListHolder
                                      completedOrderListHolder =
                                      CompletedOrderListHolder(
                                          deliveryBoyId: Utils.checkUserLoginId(
                                              psValueHolder));
                                  provider.loadCompletedOrderList(
                                      completedOrderListHolder.toMap(),
                                      TransactionParameterHolder()
                                          .getCompletedOrderParameterHolder());
                                  //
                                  pendingOrderProvider.loadPendingOrderList(
                                      completedOrderListHolder.toMap(),
                                      TransactionParameterHolder()
                                          .getPendingOrderParameterHolder());
                                }
                              },
                            );
                          } else {
                            return null;
                          }
                        },
                        childCount:
                            provider.completedTransactionList.data.length,
                      ),
                    ),
                  ]),
              onRefresh: () {
                return provider.resetCompletedOrderList(
                    completedOrderListHolder.toMap(),
                    TransactionParameterHolder()
                        .getCompletedOrderParameterHolder());
              },
            )),
          ]),
        );
      } else {
        return Container();
      }
    }));
  }
}
