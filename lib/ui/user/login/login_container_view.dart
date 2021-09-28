import 'package:flutterrtdeliveryboyapp/config/ps_colors.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_config.dart';
import 'package:flutterrtdeliveryboyapp/constant/route_paths.dart';
import 'package:flutterrtdeliveryboyapp/provider/user/user_provider.dart';
import 'package:flutterrtdeliveryboyapp/repository/user_repository.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import 'login_view.dart';

class LoginContainerView extends StatefulWidget {
  @override
  _CityLoginContainerViewState createState() => _CityLoginContainerViewState();
}

class _CityLoginContainerViewState extends State<LoginContainerView>
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
  UserProvider userProvider;
  UserRepository userRepo;

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

    final Animation<double> animation =
        Utils.getTweenAnimation(animationController, 1);

    print(
        '............................Build UI Again ............................');
    userRepo = Provider.of<UserRepository>(context);
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: _Appbar(
          title: Utils.getString(context, 'login__title'),
          scaffoldKey: scaffoldKey,
        ),
        body: LoginView(
          animationController: animationController,
          animation: animation,
        ),
      ),
    );
  }
}

class _Appbar extends StatefulWidget implements PreferredSizeWidget {
  const _Appbar(
      {Key key, @required this.title, this.scaffoldKey, this.menuDrawer})
      : super(key: key);
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Drawer menuDrawer;
  @override
  _SliverAppbarState createState() => _SliverAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class _SliverAppbarState extends State<_Appbar> {
  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      brightness: Utils.getBrightnessForAppBar(context),
      iconTheme: Theme.of(context)
          .iconTheme
          .copyWith(color: PsColors.mainColorWithWhite),
      title: Text(
        widget.title,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(fontWeight: FontWeight.bold)
            .copyWith(color: PsColors.mainColorWithWhite),
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.notifications_none,
                color: Theme.of(context).iconTheme.color),
            onPressed: () {}),
        IconButton(
          icon:
              Icon(Feather.book_open, color: Theme.of(context).iconTheme.color),
          onPressed: () {
            Navigator.pushNamed(
              context,
              RoutePaths.blogList,
            );
          },
        )
      ],
      //backgroundColor: PsColors.white,
      elevation: 0,
    );
  }
}
