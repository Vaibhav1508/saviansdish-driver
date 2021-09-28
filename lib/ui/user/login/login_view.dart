import 'dart:io';
import 'package:apple_sign_in/apple_sign_in_button.dart' as apple;
import 'package:flutterrtdeliveryboyapp/config/ps_colors.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_config.dart';
import 'package:flutterrtdeliveryboyapp/constant/ps_dimens.dart';
import 'package:flutterrtdeliveryboyapp/constant/route_paths.dart';
import 'package:flutterrtdeliveryboyapp/provider/user/user_provider.dart';
import 'package:flutterrtdeliveryboyapp/repository/user_repository.dart';
import 'package:flutterrtdeliveryboyapp/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/common/ps_button_widget.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_value_holder.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    Key key,
    this.animationController,
    this.animation,
    this.callback,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final Function callback;

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  UserRepository repo1;
  PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space28,
    );

    repo1 = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    void updateCheckBox(BuildContext context, UserProvider provider) {
      if (provider.isCheckBoxSelect) {
        provider.isCheckBoxSelect = false;
      } else {
        provider.isCheckBoxSelect = true;

        Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 1);
      }
    }

    return Stack(
      children: <Widget>[
        Container(
          color: PsColors.mainLightColor,
          width: double.infinity,
          height: double.maxFinite,
        ),
        CustomScrollView(scrollDirection: Axis.vertical, slivers: <Widget>[
          SliverToBoxAdapter(
              child: ChangeNotifierProvider<UserProvider>(
            lazy: false,
            create: (BuildContext context) {
              final UserProvider provider =
                  UserProvider(repo: repo1, psValueHolder: psValueHolder);

              return provider;
            },
            child: Consumer<UserProvider>(builder:
                (BuildContext context, UserProvider provider, Widget child) {
              return AnimatedBuilder(
                animation: widget.animationController,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _HeaderIconAndTextWidget(),
                      _TextFieldAndSignInButtonWidget(
                        provider: provider,
                        text: Utils.getString(context, 'login__submit'),
                        callback: widget.callback,
                      ),
                      _spacingWidget,
                      _DividerORWidget(),
                      const SizedBox(
                        height: PsDimens.space12,
                      ),
                      _TermsAndConCheckbox(
                        onCheckBoxClick: () {
                          setState(() {
                            updateCheckBox(context, provider);
                          });
                        },
                      ),
                      const SizedBox(
                        height: PsDimens.space8,
                      ),
                      if (PsConfig.showPhoneLogin)
                        _LoginWithPhoneWidget(
                          callback: widget.callback,
                          provider: provider,
                        ),
                      if (PsConfig.showFacebookLogin)
                        _LoginWithFbWidget(
                          userProvider: provider,
                          callback: widget.callback,
                        ),
                      if (PsConfig.showGoogleLogin)
                        _LoginWithGoogleWidget(
                          userProvider: provider,
                          callback: widget.callback,
                        ),
                      if (Utils.isAppleSignInAvailable == 1 && Platform.isIOS)
                        _LoginWithAppleIdWidget(
                          deviceToken: psValueHolder.deviceToken,
                          callback: widget.callback,
                        ),
                      _spacingWidget,
                      _ForgotPasswordAndRegisterWidget(
                        provider: provider,
                        animationController: widget.animationController,
                      ),
                      _spacingWidget,
                    ],
                  ),
                ),
                builder: (BuildContext context, Widget child) {
                  return FadeTransition(
                      opacity: widget.animation,
                      child: Transform(
                          transform: Matrix4.translationValues(
                              0.0, 100 * (1.0 - widget.animation.value), 0.0),
                          child: child));
                },
              );
            }),
          ))
        ])
      ],
    );
  }
}

class _TermsAndConCheckbox extends StatelessWidget {
  const _TermsAndConCheckbox({@required this.onCheckBoxClick});

  final Function onCheckBoxClick;

  @override
  Widget build(BuildContext context) {
    final UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Row(
      children: <Widget>[
        const SizedBox(
          width: PsDimens.space20,
        ),
        Theme(
          data: ThemeData(unselectedWidgetColor: PsColors.black),
          child: Checkbox(
            activeColor: PsColors.mainColor,
            value: _userProvider.isCheckBoxSelect,
            onChanged: (bool value) {
              onCheckBoxClick();
            },
          ),
        ),
        Expanded(
          child: InkWell(
            child: Text(Utils.getString(context, 'login__agree_privacy'),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: PsColors.black)),
            onTap: () {
              onCheckBoxClick();
            },
          ),
        ),
      ],
    );
  }
}

class _HeaderIconAndTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget _textWidget = Text(
      Utils.getString(context, 'app_name'),
      style: Theme.of(context)
          .textTheme
          .subtitle1
          .copyWith(fontWeight: FontWeight.bold, color:Colors.lightGreen),
    );

    final Widget _imageWidget = Container(
      width: 100,
      height: 100,
      child: Image.asset(
        'assets/images/logowhite.png',
      ),
    );
    return Column(
      children: <Widget>[
        const SizedBox(
          height: PsDimens.space32,
        ),
        _imageWidget,
        const SizedBox(
          height: PsDimens.space8,
        ),
        _textWidget,
        const SizedBox(
          height: PsDimens.space52,
        ),
      ],
    );
  }
}

class _TextFieldAndSignInButtonWidget extends StatefulWidget {
  const _TextFieldAndSignInButtonWidget({
    @required this.provider,
    @required this.text,
    this.callback,
  });

  final UserProvider provider;
  final String text;
  final Function callback;

  @override
  __CardWidgetState createState() => __CardWidgetState();
}

class __CardWidgetState extends State<_TextFieldAndSignInButtonWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final PsValueHolder psValueHolder =
    //     Provider.of<PsValueHolder>(context, listen: false);

    const EdgeInsets _marginEdgeInsetsforCard = EdgeInsets.only(
        left: PsDimens.space16,
        right: PsDimens.space16,
        top: PsDimens.space1,
        bottom: PsDimens.space4);
    return Column(
      children: <Widget>[
        Card(
          elevation: 0.3,
          margin: const EdgeInsets.only(
              left: PsDimens.space32, right: PsDimens.space32),
          child: Column(
            children: <Widget>[
              Container(
                margin: _marginEdgeInsetsforCard,
                child: TextField(
                  controller: emailController,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: Utils.getString(context, 'login__email'),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: PsColors.textPrimaryLightColor),
                      icon: Icon(Icons.email,
                          color: Theme.of(context).iconTheme.color)),
                ),
              ),
              const Divider(
                height: PsDimens.space1,
              ),
              Container(
                margin: _marginEdgeInsetsforCard,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: Theme.of(context).textTheme.button.copyWith(),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: Utils.getString(context, 'login__password'),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: PsColors.textPrimaryLightColor),
                      icon: Icon(Icons.lock,
                          color: Theme.of(context).iconTheme.color)),
                  // keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: PsDimens.space8,
        ),
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space32, right: PsDimens.space32),
          child: PSButtonWidget(
            hasShadow: true,
            width: double.infinity,
            titleText: Utils.getString(context, 'login__sign_in'),
            onPressed: () async {
              if (emailController.text.isEmpty) {
                callWarningDialog(context,
                    Utils.getString(context, 'warning_dialog__input_email'));
              } else if (passwordController.text.isEmpty) {
                callWarningDialog(context,
                    Utils.getString(context, 'warning_dialog__input_password'));
              } else {
                if (Utils.checkEmailFormat(emailController.text)) {
                  await widget.provider.loginWithEmailId(
                      context,
                      emailController.text,
                      passwordController.text,
                      widget.callback);
                } else {
                  callWarningDialog(context,
                      Utils.getString(context, 'warning_dialog__email_format'));
                }
              }
            },
          ),
        ),
      ],
    );
  }
}

dynamic callWarningDialog(BuildContext context, String text) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return WarningDialog(
          message: Utils.getString(context, text),
          onPressed: () {},
        );
      });
}

class _DividerORWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget _dividerWidget = Expanded(
      child: Divider(
        height: PsDimens.space2,
        color: PsColors.white,
      ),
    );

    const Widget _spacingWidget = SizedBox(
      width: PsDimens.space8,
    );

    final Widget _textWidget = Text('OR',
        style: Theme.of(context)
            .textTheme
            .subtitle2
            .copyWith(color: PsColors.black));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _dividerWidget,
        _spacingWidget,
        _textWidget,
        _spacingWidget,
        _dividerWidget,
      ],
    );
  }
}

class _LoginWithPhoneWidget extends StatefulWidget {
  const _LoginWithPhoneWidget(
      {@required this.callback, @required this.provider});
  final Function callback;
  final UserProvider provider;

  @override
  __LoginWithPhoneWidgetState createState() => __LoginWithPhoneWidgetState();
}

class __LoginWithPhoneWidgetState extends State<_LoginWithPhoneWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space32, right: PsDimens.space32),
      child: PSButtonWithIconWidget(
        titleText: Utils.getString(context, 'login__phone_signin'),
        icon: Icons.phone,
        colorData: widget.provider.isCheckBoxSelect
            ? PsColors.mainColor
            : PsColors.mainColor,
        onPressed: () async {
          if (widget.provider.isCheckBoxSelect) {
            // if (widget.onPhoneSignInSelected != null) {
            //   widget.onPhoneSignInSelected();
            // } else {
            Navigator.pushNamed(
              context,
              RoutePaths.user_phone_signin_container,
            );
            // }
          } else {
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return WarningDialog(
                    message: Utils.getString(
                        context, 'login__warning_agree_privacy'),
                    onPressed: () {},
                  );
                });
          }
        },
      ),
    );
  }
}

class _LoginWithFbWidget extends StatefulWidget {
  const _LoginWithFbWidget(
      {@required this.userProvider, @required this.callback});
  final UserProvider userProvider;
  final Function callback;

  @override
  __LoginWithFbWidgetState createState() => __LoginWithFbWidgetState();
}

class __LoginWithFbWidgetState extends State<_LoginWithFbWidget> {
  @override
  Widget build(BuildContext context) {
    // final PsValueHolder psValueHolder =
    //     Provider.of<PsValueHolder>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space32,
          top: PsDimens.space8,
          right: PsDimens.space32),
      child: PSButtonWithIconWidget(
        titleText: Utils.getString(context, 'login__fb_signin'),
        icon: FontAwesome.facebook_official,
        colorData: widget.userProvider.isCheckBoxSelect == false
            ? PsColors.facebookLoginButtonColor
            : PsColors.facebookLoginButtonColor,
        onPressed: () async {
          await widget.userProvider
              .loginWithFacebookId(context, widget.callback);
        },
      ),
    );
  }
}

class _LoginWithGoogleWidget extends StatefulWidget {
  const _LoginWithGoogleWidget(
      {@required this.userProvider, @required this.callback});
  final UserProvider userProvider;
  final Function callback;

  @override
  __LoginWithGoogleWidgetState createState() => __LoginWithGoogleWidgetState();
}

class __LoginWithGoogleWidgetState extends State<_LoginWithGoogleWidget> {
  @override
  Widget build(BuildContext context) {
    // final PsValueHolder psValueHolder =
    //     Provider.of<PsValueHolder>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space32,
          top: PsDimens.space8,
          right: PsDimens.space32),
      child: PSButtonWithIconWidget(
        titleText: Utils.getString(context, 'login__google_signin'),
        icon: FontAwesome.google,
        colorData: widget.userProvider.isCheckBoxSelect
            ? PsColors.googleLoginButtonColor
            : PsColors.googleLoginButtonColor,
        onPressed: () async {
          await widget.userProvider.loginWithGoogleId(context, widget.callback);
        },
      ),
    );
  }
}

class _LoginWithAppleIdWidget extends StatelessWidget {
  const _LoginWithAppleIdWidget(
      {@required this.deviceToken, @required this.callback});

  final Function callback;
  final String deviceToken;

  @override
  Widget build(BuildContext context) {
    final UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);

    return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space32,
            top: PsDimens.space8,
            right: PsDimens.space32),
        child: Directionality(
          // add this
          textDirection: TextDirection.ltr,
          child: apple.AppleSignInButton(
            style: apple.ButtonStyle.black, // style as needed
            type: apple.ButtonType.signIn, // style as needed

            onPressed: () async {
              await _userProvider.loginWithAppleId(
                  context, deviceToken, callback, _userProvider);
            },
          ),
        ));
  }
}

class _ForgotPasswordAndRegisterWidget extends StatefulWidget {
  const _ForgotPasswordAndRegisterWidget({
    Key key,
    this.provider,
    this.animationController,
  }) : super(key: key);

  final AnimationController animationController;
  final UserProvider provider;

  @override
  __ForgotPasswordAndRegisterWidgetState createState() =>
      __ForgotPasswordAndRegisterWidgetState();
}

class __ForgotPasswordAndRegisterWidgetState
    extends State<_ForgotPasswordAndRegisterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: PsDimens.space40),
      margin: const EdgeInsets.all(PsDimens.space12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: GestureDetector(
              child: Text(
                Utils.getString(context, 'login__forgot_password'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button.copyWith(
                      color: PsColors.mainColor,
                    ),
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RoutePaths.user_forgot_password_container,
                );
              },
            ),
          ),
          Flexible(
            child: GestureDetector(
              child: Text(
                Utils.getString(context, 'login__sign_up'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button.copyWith(
                      color: PsColors.mainColor,
                    ),
              ),
              onTap: () async {
                // if (widget.onSignInSelected != null) {
                //   widget.onSignInSelected();
                // } else {
                final dynamic returnData = await Navigator.pushNamed(
                  context,
                  RoutePaths.user_register_container,
                );
                if (returnData != null && returnData is User) {
                  final User user = returnData;

                  Navigator.pop(context, user);
                }
                // }
              },
            ),
          ),
        ],
      ),
    );
  }
}
