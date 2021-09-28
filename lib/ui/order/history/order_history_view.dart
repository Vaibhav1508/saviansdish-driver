import 'package:flutterrtdeliveryboyapp/config/ps_colors.dart';
import 'package:flutterrtdeliveryboyapp/constant/ps_constants.dart';
import 'package:flutterrtdeliveryboyapp/constant/ps_dimens.dart';
import 'package:flutterrtdeliveryboyapp/provider/transaction/completed_order_provider.dart';
import 'package:flutterrtdeliveryboyapp/repository/transaction_header_repository.dart';
import 'package:flutterrtdeliveryboyapp/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterrtdeliveryboyapp/ui/order/item/order_list_item.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/holder/completed_order_list_holder.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_parameter_holder.dart';
import 'package:provider/provider.dart';
import 'package:flutterrtdeliveryboyapp/constant/route_paths.dart';
import 'package:flutterrtdeliveryboyapp/ui/common/ps_ui_widget.dart';

class OrderHistoryListView extends StatefulWidget {
  const OrderHistoryListView(
      {Key key, @required this.animationController, @required this.scaffoldKey})
      : super(key: key);
  final AnimationController animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  _OrderHistoryListViewState createState() => _OrderHistoryListViewState();
}

class _OrderHistoryListViewState extends State<OrderHistoryListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  CompletedOrderProvider _orderHistoryProvider;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _orderHistoryProvider.nextCompletedOrderList(
            completedOrderListHolder.toMap(),
            TransactionParameterHolder().getCompletedOrderParameterHolder());
      }
    });

    super.initState();
  }

  TransactionHeaderRepository repo1;
  PsValueHolder psValueHolder;
  dynamic data;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  CompletedOrderListHolder completedOrderListHolder;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConst.SHOW_ADMOB) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && PsConst.SHOW_ADMOB) {
      print('loading ads....');
      checkConnection();
    }
    repo1 = Provider.of<TransactionHeaderRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    print(
        '............................Build UI Again ............................');
    return ChangeNotifierProvider<CompletedOrderProvider>(
      lazy: false,
      create: (BuildContext context) {
        final CompletedOrderProvider provider =
            CompletedOrderProvider(repo: repo1);
        completedOrderListHolder =
            CompletedOrderListHolder(deliveryBoyId: psValueHolder.loginUserId);
        provider.loadCompletedOrderList(completedOrderListHolder.toMap(),
            TransactionParameterHolder().getCompletedOrderParameterHolder());
        _orderHistoryProvider = provider;
        return _orderHistoryProvider;
      },
      child: Consumer<CompletedOrderProvider>(builder: (BuildContext context,
          CompletedOrderProvider provider, Widget child) {
        if (provider.completedTransactionList.data != null) {
          if (provider.completedTransactionList.data.isNotEmpty) {
            return Column(
              children: <Widget>[
                const PsAdMobBannerWidget(),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      RefreshIndicator(
                        child: CustomScrollView(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    final int count = provider
                                        .completedTransactionList.data.length;
                                    return OrderListItem(
                                      scaffoldKey: widget.scaffoldKey,
                                      animationController:
                                          widget.animationController,
                                      animation:
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(
                                        CurvedAnimation(
                                          parent: widget.animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        ),
                                      ),
                                      transaction: provider
                                          .completedTransactionList.data[index],
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            RoutePaths.transactionDetail,
                                            arguments: provider
                                                .completedTransactionList
                                                .data[index]);
                                      },
                                    );
                                  },
                                  childCount: provider
                                      .completedTransactionList.data.length,
                                ),
                              ),
                            ]),
                        onRefresh: () {
                          return provider.resetCompletedOrderList(
                              completedOrderListHolder.toMap(),
                              TransactionParameterHolder()
                                  .getCompletedOrderParameterHolder());
                        },
                      ),
                      PSProgressIndicator(
                          provider.completedTransactionList.status)
                    ],
                  ),
                )
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: PsDimens.space44),
                child: Container(
                  color: PsColors.backgroundColor,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.only(bottom: PsDimens.space120),
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
                      const SizedBox(
                        height: PsDimens.space8,
                      ),
                      Text(
                        Utils.getString(
                            context, 'order_history_list__empty_title'),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(),
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
                                  context, 'order_history_list__empty_desc'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        } else {
          return Container();
        }
      }),
    );
  }
}
