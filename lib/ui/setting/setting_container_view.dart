import 'package:flutterrtdeliveryboyapp/config/ps_colors.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_config.dart';
import 'package:flutterrtdeliveryboyapp/ui/setting/setting_view.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:flutter/material.dart';

class SettingContainerView extends StatefulWidget {
  @override
  _SettingContainerViewState createState() => _SettingContainerViewState();
}

class _SettingContainerViewState extends State<SettingContainerView>
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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
          appBar: AppBar(
            brightness: Utils.getBrightnessForAppBar(context),
            iconTheme: Theme.of(context)
                .iconTheme
                .copyWith(color: PsColors.mainColorWithWhite),
            title: Text(
              Utils.getString(context, 'Setting'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: PsColors.mainColorWithWhite, fontWeight: FontWeight.bold),
            ),
            elevation: 0,
          ),
          body: Container(
            color: PsColors.coreBackgroundColor,
            height: double.infinity,
            child: SettingView(
              animationController: animationController,
            ),
          )),
    );
  }
}
