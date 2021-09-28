import 'package:flutterrtdeliveryboyapp/config/ps_colors.dart';
import 'package:flutterrtdeliveryboyapp/constant/ps_constants.dart';
import 'package:flutterrtdeliveryboyapp/constant/ps_dimens.dart';
import 'package:flutterrtdeliveryboyapp/constant/route_paths.dart';
import 'package:flutterrtdeliveryboyapp/provider/common/main_dashboard_provider.dart';
import 'package:flutterrtdeliveryboyapp/provider/user/user_provider.dart';
import 'package:flutterrtdeliveryboyapp/repository/user_repository.dart';
import 'package:flutterrtdeliveryboyapp/ui/common/ps_ui_widget.dart';
import 'package:flutterrtdeliveryboyapp/ui/user/login/login_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/user/pending_user/pending_user_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/user/reject_user/reject_user_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/user/verify/verify_email_view.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key key, this.animationController}) : super(key: key);
  final AnimationController animationController;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  UserRepository userRepository;
  PsValueHolder psValueHolder;

  Future<void> updateTitle(MainDashboardProvider provider, String title) async {
    provider.updateIndex(provider.currentIndex, title, mounted);
  }

  MainDashboardProvider provider;
  @override
  void initState() {
    Utils.psPrint('** Init State at Profile View');

    super.initState();

    provider = Provider.of<MainDashboardProvider>(context, listen: false);
  }

  bool isFirst = false;
  @override
  Widget build(BuildContext context) {
    Utils.psPrint('Build Profile View');
    final Animation<double> animation =
        Utils.getTweenAnimation(widget.animationController, 1);

    psValueHolder = Provider.of<PsValueHolder>(context);

    Utils.psPrint(psValueHolder.loginUserId);
    Utils.psPrint(psValueHolder.isDeliveryBoy);
    widget.animationController.forward();

    // Is user to login
    if (psValueHolder.isUserToLogin()) {
      updateTitle(provider, Utils.getString(context, 'login__title'));
      return LoginView(
        animationController: widget.animationController,
        animation: animation,
        callback: () {
          provider.updateIndex(PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
              Utils.getString(context, 'app_name'), mounted);
        },
      );
    }
    // Is user to verify
    else if (psValueHolder.isUserToVerfity()) {
      updateTitle(provider, Utils.getString(context, 'email_verify__title'));
      return VerifyEmailView(
        animationController: widget.animationController,
        callback: () {
          provider.updateIndex(PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
              Utils.getString(context, 'app_name'), mounted);
        },
      );
    }

    // Is user delivery boy status is pending
    else if (psValueHolder.isDeliveryBoy == PsConst.PENDING_STATUS) {
      updateTitle(
          provider, Utils.getString(context, 'user__wait_approve_title'));
      return const PendingUserView();
    }
    // Is user delivery boy status is rejected
    else if (psValueHolder.isDeliveryBoy == PsConst.REJECT_STATUS) {
      updateTitle(provider, Utils.getString(context, 'user__reject_title'));
      return const RejectUserView();
    }

    updateTitle(provider, Utils.getString(context, 'profile__title'));
    // return SingleChildScrollView(
    //     child: Container(
    //   color: PsColors.coreBackgroundColor,
    //   height: double.maxFinite,
    //   child: 
      return CustomScrollView(scrollDirection: Axis.vertical, slivers: <Widget>[
        _ProfileDetailWidget(
          animationController: widget.animationController,
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: widget.animationController,
              curve:
                  const Interval((1 / 4) * 2, 1.0, curve: Curves.fastOutSlowIn),
            ),
          ),
          userId: psValueHolder.loginUserId,
        ),
      ]
    );
  }
}

class _ProfileDetailWidget extends StatefulWidget {
  const _ProfileDetailWidget({
    Key key,
    this.animationController,
    this.animation,
    @required this.userId,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final String userId;

  @override
  __ProfileDetailWidgetState createState() => __ProfileDetailWidgetState();
}

class __ProfileDetailWidgetState extends State<_ProfileDetailWidget> {
  UserRepository userRepository;
  PsValueHolder psValueHolder;
  UserProvider provider;
  @override
  Widget build(BuildContext context) {
    const Widget _dividerWidget = Divider(
      height: 1,
    );

    userRepository = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<UserProvider>(
            lazy: false,
            create: (BuildContext context) {
              provider = UserProvider(
                  repo: userRepository, psValueHolder: psValueHolder);
              if (!psValueHolder.isUserToLogin()) {
                provider.getUser(psValueHolder.loginUserId);
              }
              return provider;
            },
            child: Consumer<UserProvider>(builder:
                (BuildContext context, UserProvider provider, Widget child) {
              Utils.psPrint(provider.user.status.toString());
              if (provider.user != null &&
                  provider.user.data != null &&
                  provider.user.data.userFlag != null) {
                return AnimatedBuilder(
                    animation: widget.animationController,
                    child: Container(
                      color: PsColors.backgroundColor,
                      child: Column(
                        children: <Widget>[
                          _ImageAndTextWidget(userProvider: provider),
                          _dividerWidget,
                          _FavAndSettingWidget(
                              userProvider: provider,
                              userLoginProvider: provider),
                          _dividerWidget,
                          _JoinDateWidget(userProvider: provider),
                          _dividerWidget,
                        ],
                      ),
                    ),
                    builder: (BuildContext context, Widget child) {
                      return FadeTransition(
                          opacity: widget.animation,
                          child: Transform(
                              transform: Matrix4.translationValues(0.0,
                                  100 * (1.0 - widget.animation.value), 0.0),
                              child: child));
                    });
              } else {
                return Container();
              }
            })));
  }
}

class _JoinDateWidget extends StatelessWidget {
  const _JoinDateWidget({this.userProvider});
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Utils.getString(context, 'profile__join_on'),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(
                  width: PsDimens.space2,
                ),
                Text(userProvider.user.data.addedDate,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyText1),
              ],
            )));
  }
}

class _FavAndSettingWidget extends StatelessWidget {
  const _FavAndSettingWidget({
    @required this.userLoginProvider,
    @required this.userProvider,
  });
  final UserProvider userLoginProvider;
  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);

    const Widget _sizedBoxWidget = SizedBox(
      width: PsDimens.space4,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
            flex: 2,
            child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () async {
                final dynamic returnData = await Navigator.pushNamed(
                  context,
                  RoutePaths.editProfile,
                );
                if (returnData) {
                  userLoginProvider.getUser(psValueHolder.loginUserId);
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.edit,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  _sizedBoxWidget,
                  Text(
                    Utils.getString(context, 'profile__edit'),
                    textAlign: TextAlign.start,
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
        Container(
          color: Theme.of(context).dividerColor,
          width: PsDimens.space1,
          height: PsDimens.space48,
        ),
        Expanded(
            flex: 2,
            child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.pushNamed(context, RoutePaths.more,
                    arguments: userProvider.user.data.userName);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.more_horiz,
                      color: Theme.of(context).iconTheme.color),
                  _sizedBoxWidget,
                  Text(
                    Utils.getString(context, 'profile__more'),
                    softWrap: false,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget({this.userProvider});

  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    final Widget _imageWidget = PsNetworkCircleImageForUser(
      photoKey: '',
      imagePath: userProvider.user.data.userProfilePhoto,
      width: PsDimens.space80,
      height: PsDimens.space80,
      boxfit: BoxFit.cover,
      onTap: () async {
        final dynamic returnData = await Navigator.pushNamed(
          context,
          RoutePaths.editProfile,
        );
        if (returnData) {
          userProvider.getUser(psValueHolder.loginUserId);
        }
      },
    );
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space4,
    );
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
          top: PsDimens.space16, bottom: PsDimens.space16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const SizedBox(width: PsDimens.space16),
              _imageWidget,
              const SizedBox(width: PsDimens.space16),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  userProvider.user.data.userName,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline6,
                  maxLines: 1,
                ),
                _spacingWidget,
                Text(
                  userProvider.user.data.userPhone != ''
                      ? userProvider.user.data.userPhone
                      : Utils.getString(context, 'profile__phone_no'),
                  style: Theme.of(context).textTheme.bodyText1,
                  maxLines: 1,
                ),
                _spacingWidget,
                Text(
                  userProvider.user.data.userAboutMe != ''
                      ? userProvider.user.data.userAboutMe
                      : Utils.getString(context, 'profile__about_me'),
                  style: Theme.of(context).textTheme.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
