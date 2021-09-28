import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_colors.dart';
import 'package:flutterrtdeliveryboyapp/constant/ps_constants.dart';
import 'package:flutterrtdeliveryboyapp/constant/ps_dimens.dart';
import 'package:flutterrtdeliveryboyapp/provider/common/main_dashboard_provider.dart';
import 'package:flutterrtdeliveryboyapp/provider/delete_task/delete_task_provider.dart';
import 'package:flutterrtdeliveryboyapp/provider/user/user_login_provider.dart';
import 'package:flutterrtdeliveryboyapp/provider/user/user_provider.dart';
import 'package:flutterrtdeliveryboyapp/repository/delete_task_repository.dart';
import 'package:flutterrtdeliveryboyapp/repository/user_repository.dart';
import 'package:flutterrtdeliveryboyapp/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_value_holder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class CoreDrawerDashboardView extends StatefulWidget {
  const CoreDrawerDashboardView(
      {Key key,
      @required this.userRepository,
      @required this.deleteTaskRepository,
      // @required this.valueHolder,
      @required this.updateSelectedIndexWithAnimation})
      : super(key: key);

  final UserRepository userRepository;
  final DeleteTaskRepository deleteTaskRepository;
  final Function updateSelectedIndexWithAnimation;

  @override
  _CoreDrawerDashboardViewState createState() =>
      _CoreDrawerDashboardViewState();
}

class _CoreDrawerDashboardViewState extends State<CoreDrawerDashboardView> {
  DeleteTaskProvider deleteTaskProvider;
  MainDashboardProvider mainDashboardProvider;
  @override
  Widget build(BuildContext context) {
    final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);
    mainDashboardProvider =
        Provider.of<MainDashboardProvider>(context, listen: false);
    return Drawer(
      child: MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<UserProvider>(
              lazy: false,
              create: (BuildContext context) {
                return UserProvider(
                    repo: widget.userRepository, psValueHolder: valueHolder);
              }),
          ChangeNotifierProvider<DeleteTaskProvider>(
              lazy: false,
              create: (BuildContext context) {
                deleteTaskProvider =
                    DeleteTaskProvider(repo: widget.deleteTaskRepository);
                return deleteTaskProvider;
              }),
        ],
        child: Consumer<UserProvider>(
          builder: (BuildContext context, UserProvider provider, Widget child) {
            print(valueHolder.loginUserId);

            Provider.of<DeleteTaskProvider>(context, listen: false);
            return ListView(padding: EdgeInsets.zero, children: <Widget>[
              _DrawerHeaderWidget(),
              ListTile(
                title: Text(Utils.getString(context, 'home__drawer_menu_home')),
              ),
              _DrawerMenuWidget(
                  icon: Icons.store,
                  title: Utils.getString(context, 'home__drawer_menu_home'),
                  index: PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
                  onTap: (String title, int index) {
                    Navigator.pop(context);
                    widget.updateSelectedIndexWithAnimation(
                        Utils.getString(context, 'app_name'), index);
                  }),
              const Divider(
                height: PsDimens.space1,
              ),
              ListTile(
                title: Text(
                    Utils.getString(context, 'home__menu_drawer_user_info')),
              ),
              _DrawerMenuWidget(
                  icon: Icons.person,
                  title: Utils.getString(context, 'home__menu_drawer_profile'),
                  index: PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                  onTap: (String title, int index) {
                    Navigator.pop(context);
                    title = (valueHolder == null ||
                            valueHolder.userIdToVerify == null ||
                            valueHolder.userIdToVerify == '')
                        ? Utils.getString(context, 'home__menu_drawer_profile')
                        : Utils.getString(
                            context, 'home__bottom_app_bar_verify_email');

                    // Is user to login
                    if (valueHolder.isUserToLogin()) {
                      title = 'Login';
                    }
                    // Is user to verify
                    else if (valueHolder.isUserToVerfity()) {
                      title = 'Verify';
                    }
                    // Is user delivery boy status is pending
                    else if (valueHolder.isDeliveryBoy ==
                        PsConst.PENDING_STATUS) {
                      title = 'Pending';
                    }
                    // Is user delivery boy status is rejected
                    else if (valueHolder.isDeliveryBoy ==
                        PsConst.REJECT_STATUS) {
                      title = 'Reject';
                    } else {
                      title = 'Profile';
                    }

                    widget.updateSelectedIndexWithAnimation(title, index);
                  }),
              if (provider != null)
                if (valueHolder.loginUserId != null &&
                    valueHolder.loginUserId != '' &&
                    valueHolder.isDeliveryBoy == PsConst.APPROVED_STATUS)
                  Visibility(
                    visible: true,
                    child: _DrawerMenuWidget(
                        icon: Icons.swap_horizontal_circle,
                        title: Utils.getString(
                            context, 'home__menu_drawer_active_order'),
                        index: PsConst.REQUEST_CODE__MENU_ACTIVE_ORDER_FRAGMENT,
                        onTap: (String title, int index) {
                          Navigator.pop(context);
                          widget.updateSelectedIndexWithAnimation(title, index);
                        }),
                  ),
              if (provider != null)
                if (valueHolder.loginUserId != null &&
                    valueHolder.loginUserId != '' &&
                    valueHolder.isDeliveryBoy == PsConst.APPROVED_STATUS)
                  Visibility(
                    visible: true,
                    child: _DrawerMenuWidget(
                      icon: Icons.swap_horiz,
                      title: Utils.getString(
                          context, 'home__menu_drawer_order_history'),
                      index: PsConst.REQUEST_CODE__MENU_ORDER_HISTORY_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        widget.updateSelectedIndexWithAnimation(title, index);
                      },
                    ),
                  ),
              if (provider != null)
                if (valueHolder.loginUserId != null &&
                    valueHolder.loginUserId != '')
                  Visibility(
                    visible: true,
                    child: ListTile(
                      leading: Icon(
                        Icons.power_settings_new,
                        color: PsColors.mainColorWithWhite,
                      ),
                      title: Text(
                        Utils.getString(context, 'home__menu_drawer_logout'),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmDialogView(
                                  description: Utils.getString(context,
                                      'home__logout_dialog_description'),
                                  leftButtonText: Utils.getString(context,
                                      'home__logout_dialog_cancel_button'),
                                  rightButtonText: Utils.getString(
                                      context, 'home__logout_dialog_ok_button'),
                                  onAgreeTap: () async {
                                   await provider.replaceLoginUserId('');
                                   await provider.replaceIsDeliveryBoy('');
                                    await deleteTaskProvider.deleteTask();
                                    await FacebookLogin().logOut();
                                    await GoogleSignIn().signOut();
                                    await FirebaseAuth.instance.signOut();

                                    Navigator.of(context).pop();
                                    // mainDashboardProvider.updateIndex(
                                    //     PsConst
                                    //         .REQUEST_CODE__MENU_HOME_FRAGMENT,
                                    //     Utils.getString(context, 'app_name'),
                                    //     mounted);
                                    widget.updateSelectedIndexWithAnimation(
                                        Utils.getString(context, 'app_name'),
                                        PsConst
                                            .REQUEST_CODE__MENU_HOME_FRAGMENT);
                                  });
                            });
                      },
                    ),
                  ),
              const Divider(
                height: PsDimens.space1,
              ),
              ListTile(
                title: Text(Utils.getString(context, 'home__menu_drawer_app')),
              ),
              _DrawerMenuWidget(
                  icon: Icons.g_translate,
                  title: Utils.getString(context, 'home__menu_drawer_language'),
                  index: PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT,
                  onTap: (String title, int index) {
                    Navigator.pop(context);
                    widget.updateSelectedIndexWithAnimation('', index);
                  }),
              _DrawerMenuWidget(
                  icon: Icons.contacts,
                  title:
                      Utils.getString(context, 'home__menu_drawer_contact_us'),
                  index: PsConst.REQUEST_CODE__MENU_CONTACT_US_FRAGMENT,
                  onTap: (String title, int index) {
                    Navigator.pop(context);
                    widget.updateSelectedIndexWithAnimation(title, index);
                  }),
              _DrawerMenuWidget(
                  icon: Icons.settings,
                  title: Utils.getString(context, 'home__menu_drawer_setting'),
                  index: PsConst.REQUEST_CODE__MENU_SETTING_FRAGMENT,
                  onTap: (String title, int index) {
                    Navigator.pop(context);
                    widget.updateSelectedIndexWithAnimation(title, index);
                  }),

            ]);
          },
        ),
      ),
    );
  }
}


class _DrawerHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/transparent.png',
            width: PsDimens.space100,
            height: PsDimens.space72,
          ),
          const SizedBox(
            height: PsDimens.space8,
          ),
          Text(
            Utils.getString(context, 'app_name'),
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: Colors.white),
          ),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
          PsColors.mainColor,
          PsColors.mainDarkColor,
        ]),),
    );
  }
}

class _DrawerMenuWidget extends StatefulWidget {
  const _DrawerMenuWidget({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.onTap,
    @required this.index,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Function onTap;
  final int index;

  @override
  __DrawerMenuWidgetState createState() => __DrawerMenuWidgetState();
}

class __DrawerMenuWidgetState extends State<_DrawerMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(widget.icon, color: PsColors.mainColorWithWhite),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        onTap: () {
          widget.onTap(widget.title, widget.index);
        });
  }
}
