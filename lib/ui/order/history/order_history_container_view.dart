import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_colors.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_config.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';

import 'order_history_view.dart';

class CompletedOrderListContainerView extends StatefulWidget {
  @override
  _CompletedOrderListContainerViewState createState() =>
      _CompletedOrderListContainerViewState();
}

class _CompletedOrderListContainerViewState
    extends State<CompletedOrderListContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          brightness: Utils.getBrightnessForAppBar(context),
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: PsColors.mainColorWithWhite),
          title: Text(
            Utils.getString(context, 'profile__order'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6.copyWith(
                fontWeight: FontWeight.bold,
                color: PsColors.mainColorWithWhite),
          ),
          elevation: 0,
        ),
        body: OrderHistoryListView(
          scaffoldKey: scaffoldKey,
          animationController: animationController,
        ),
      ),
    );
  }
}
