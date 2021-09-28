import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_colors.dart';
import 'package:flutterrtdeliveryboyapp/provider/common/main_dashboard_provider.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:provider/provider.dart';

class CoreAppBarDashboardView extends StatelessWidget
    implements PreferredSizeWidget {
  const CoreAppBarDashboardView({
    Key key,
    @required this.appBarTitle,
  }) : super(key: key);

  final String appBarTitle;

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
            PsColors.mainColor,
            PsColors.mainDarkColor,
          ]),
        ),
      ),
      title: Consumer<MainDashboardProvider>(
        builder: (BuildContext context, MainDashboardProvider provider,
            Widget child) {
          return Text(provider.appBarTitle,
              style: Theme.of(context).textTheme.headline6.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white));
        },
      ),
      titleSpacing: 0,
      elevation: 0,
      iconTheme: IconThemeData(
          color: Colors.white),
      textTheme: Theme.of(context).textTheme,
      brightness: Utils.getBrightnessForAppBar(context),
    );
  }
}
