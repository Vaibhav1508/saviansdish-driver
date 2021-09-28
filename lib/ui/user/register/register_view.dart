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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({
    Key key,
    this.animationController,
    // this.onRegisterSelected,
    // this.goToLoginSelected
  }) : super(key: key);
  final AnimationController animationController;
  // final Function onRegisterSelected, goToLoginSelected;
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  UserRepository repo1;
  PsValueHolder valueHolder;
  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController passwordController;

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
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    animationController.forward();

    repo1 = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return Stack(children: <Widget>[
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
                  UserProvider(repo: repo1, psValueHolder: valueHolder);

              return provider;
            },
            child: Consumer<UserProvider>(builder:
                (BuildContext context, UserProvider provider, Widget child) {
              nameController =
                  TextEditingController(text: valueHolder.userNameToVerify);
              emailController =
                  TextEditingController(text: valueHolder.userEmailToVerify);
              passwordController =
                  TextEditingController(text: valueHolder.userPasswordToVerify);

              return Stack(
                children: <Widget>[
                  SingleChildScrollView(
                      child: AnimatedBuilder(
                          animation: animationController,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              _HeaderIconAndTextWidget(),
                              _TextFieldWidget(
                                nameText: nameController,
                                emailText: emailController,
                                passwordText: passwordController,
                              ),
                              const SizedBox(
                                height: PsDimens.space8,
                              ),
                              _TermsAndConCheckbox(
                                provider: provider,
                                nameTextEditingController:
                                    nameController,
                                emailTextEditingController:
                                    emailController,
                                passwordTextEditingController:
                                    passwordController,
                              ),
                              const SizedBox(
                                height: PsDimens.space8,
                              ),
                              _SignInButtonWidget(
                                provider: provider,
                                nameTextEditingController:
                                    nameController,
                                emailTextEditingController:
                                    emailController,
                                passwordTextEditingController:
                                    passwordController,
                                // onRegisterSelected:
                                //     widget.onRegisterSelected,
                              ),
                              const SizedBox(
                                height: PsDimens.space16,
                              ),
                              const _TextWidget(
                                  // goToLoginSelected:
                                  //     widget.goToLoginSelected,
                                  ),
                              const SizedBox(
                                height: PsDimens.space64,
                              ),
                            ],
                          ),
                          builder: (BuildContext context, Widget child) {
                            return FadeTransition(
                                opacity: animation,
                                child: Transform(
                                  transform: Matrix4.translationValues(
                                      0.0, 100 * (1.0 - animation.value), 0.0),
                          child: child
                          ));
                      }))
                ],
              );
            }),
          ),
        )
      ])
    ]);
  }
}

class _TermsAndConCheckbox extends StatefulWidget {
  const _TermsAndConCheckbox({
    @required this.provider,
    @required this.nameTextEditingController,
    @required this.emailTextEditingController,
    @required this.passwordTextEditingController,
  });

  final UserProvider provider;
  final TextEditingController nameTextEditingController,
      emailTextEditingController,
      passwordTextEditingController;
  @override
  __TermsAndConCheckboxState createState() => __TermsAndConCheckboxState();
}

class __TermsAndConCheckboxState extends State<_TermsAndConCheckbox> {
  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    return Row(
      children: <Widget>[
        const SizedBox(
          width: PsDimens.space20,
        ),
        Theme(
          data: ThemeData(unselectedWidgetColor: PsColors.black),
          child: Checkbox(
            activeColor: PsColors.mainColor,
            value: widget.provider.isCheckBoxSelect,
            onChanged: (bool value) {
              setState(() {
                updateCheckBox(
                    widget.provider.isCheckBoxSelect,
                    context,
                    widget.provider,
                    psValueHolder,
                    widget.nameTextEditingController,
                    widget.emailTextEditingController,
                    widget.passwordTextEditingController);
              });
            },
          ),
        ),
        Expanded(
          child: InkWell(
            child: Text(
              Utils.getString(context, 'login__agree_privacy'),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: PsColors.black),
            ),
            onTap: () {
              setState(() {
                updateCheckBox(
                    widget.provider.isCheckBoxSelect,
                    context,
                    widget.provider,
                    psValueHolder,
                    widget.nameTextEditingController,
                    widget.emailTextEditingController,
                    widget.passwordTextEditingController);
              });
            },
          ),
        ),
      ],
    );
  }
}

void updateCheckBox(
    bool isCheckBoxSelect,
    BuildContext context,
    UserProvider provider,
    PsValueHolder psValueHolder,
    TextEditingController nameTextEditingController,
    TextEditingController emailTextEditingController,
    TextEditingController passwordTextEditingController) {
  if (isCheckBoxSelect) {
    provider.isCheckBoxSelect = false;
  } else {
    provider.isCheckBoxSelect = true;
    psValueHolder.userNameToVerify = nameTextEditingController.text;
    psValueHolder.userEmailToVerify = emailTextEditingController.text;
    psValueHolder.userPasswordToVerify = passwordTextEditingController.text;
    Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 1);
  }
}

class _TextWidget extends StatefulWidget {
  const _TextWidget();
  // final Function goToLoginSelected;
  @override
  __TextWidgetState createState() => __TextWidgetState();
}

class __TextWidgetState extends State<_TextWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        Utils.getString(context, 'register__login'),
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(color: PsColors.mainColor),
      ),
      onTap: () {
        // if (widget.goToLoginSelected != null) {
        //   widget.goToLoginSelected();
        // } else {
        // Navigator.pushReplacementNamed(
        //   context,
        //   RoutePaths.login_container,
        // );
        // }
        Navigator.pop(context);
      },
    );
  }
}

class _TextFieldWidget extends StatefulWidget {
  const _TextFieldWidget({
    @required this.nameText,
    @required this.emailText,
    @required this.passwordText,
  });

  final TextEditingController nameText, emailText, passwordText;
  @override
  __TextFieldWidgetState createState() => __TextFieldWidgetState();
}

class __TextFieldWidgetState extends State<_TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    const EdgeInsets _marginEdgeInsetWidget = EdgeInsets.only(
        left: PsDimens.space16,
        right: PsDimens.space16,
        top: PsDimens.space4,
        bottom: PsDimens.space4);

    const Widget _dividerWidget = Divider(
      height: PsDimens.space1,
    );
    return Card(
      elevation: 0.3,
      margin: const EdgeInsets.only(
          left: PsDimens.space32, right: PsDimens.space32),
      child: Column(
        children: <Widget>[
          Container(
            margin: _marginEdgeInsetWidget,
            child: TextField(
              controller: widget.nameText,
              style: Theme.of(context).textTheme.button.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'register__user_name'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: PsColors.textPrimaryLightColor),
                  icon: Icon(Icons.people,
                      color: Theme.of(context).iconTheme.color)),
            ),
          ),
          _dividerWidget,
          Container(
            margin: _marginEdgeInsetWidget,
            child: TextField(
              controller: widget.emailText,
              keyboardType: TextInputType.emailAddress,
              style: Theme.of(context).textTheme.button.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'register__email'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: PsColors.textPrimaryLightColor),
                  icon: Icon(Icons.email,
                      color: Theme.of(context).iconTheme.color)),
            ),
          ),
          _dividerWidget,
          Container(
            margin: _marginEdgeInsetWidget,
            child: TextField(
              controller: widget.passwordText,
              obscureText: true,
              style: Theme.of(context).textTheme.button.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'register__password'),
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
    );
  }
}

class _HeaderIconAndTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: PsDimens.space32,
        ),
        Container(
          width: 90,
          height: 90,
          child: Image.asset(
            'assets/images/app_icon.png',
          ),
        ),
        const SizedBox(
          height: PsDimens.space8,
        ),
        Text(
          Utils.getString(context, 'app_name'),
          style: Theme.of(context).textTheme.subtitle2.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
        const SizedBox(
          height: PsDimens.space52,
        ),
      ],
    );
  }
}

class _SignInButtonWidget extends StatefulWidget {
  const _SignInButtonWidget(
      {@required this.provider,
      @required this.nameTextEditingController,
      @required this.emailTextEditingController,
      @required this.passwordTextEditingController});
  final UserProvider provider;
  final TextEditingController nameTextEditingController,
      emailTextEditingController,
      passwordTextEditingController;

  @override
  __SignInButtonWidgetState createState() => __SignInButtonWidgetState();
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

class __SignInButtonWidgetState extends State<_SignInButtonWidget> {
  @override
  Widget build(BuildContext context) {
    // final PsValueHolder psValueHolder =
    //     Provider.of<PsValueHolder>(context, listen: false);
    return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space32, right: PsDimens.space32),
        child: PSButtonWidget(
          hasShadow: true,
          width: double.infinity,
          titleText: Utils.getString(context, 'register__register'),
          onPressed: () async {
            // if (widget.provider.isCheckBoxSelect) {
            //
            if (widget.nameTextEditingController.text.isEmpty) {
              callWarningDialog(context,
                  Utils.getString(context, 'warning_dialog__input_name'));
            } else if (widget.emailTextEditingController.text.isEmpty) {
              callWarningDialog(context,
                  Utils.getString(context, 'warning_dialog__input_email'));
            } else if (widget.passwordTextEditingController.text.isEmpty) {
              callWarningDialog(context,
                  Utils.getString(context, 'warning_dialog__input_password'));
            } else {
              if(Utils.checkEmailFormat(widget.emailTextEditingController.text)){
              await widget.provider.signUpWithEmailId(
                  context,
                  null,
                  widget.nameTextEditingController.text,
                  widget.emailTextEditingController.text,
                  widget.passwordTextEditingController.text);
               }else{
                callWarningDialog(context,
                Utils.getString(context, 'warning_dialog__email_format'));
                }

              // if (await Utils.checkInternetConnectivity()) {
              //   final UserRegisterParameterHolder
              //       userRegisterParameterHolder = UserRegisterParameterHolder(
              //           userId: '',
              //           userName: widget.nameTextEditingController.text,
              //           userEmail: widget.emailTextEditingController.text,
              //           userPassword:
              //               widget.passwordTextEditingController.text,
              //           userPhone: '',
              //           deviceToken: psValueHolder.deviceToken,
              //           isDeliveryBoy: PsConst.ONE);

              //   final PsResource<User> _apiStatus = await widget.provider
              //       .postUserRegister(userRegisterParameterHolder.toMap());

              //   if (_apiStatus.data != null) {
              //     final User user = _apiStatus.data;

              //     //verify
              //     await widget.provider.replaceVerifyUserData(
              //         _apiStatus.data.userId,
              //         _apiStatus.data.userName,
              //         _apiStatus.data.userEmail,
              //         widget.passwordTextEditingController.text);

              //     psValueHolder.userIdToVerify = user.userId;
              //     psValueHolder.userNameToVerify = user.userName;
              //     psValueHolder.userEmailToVerify = user.userEmail;
              //     psValueHolder.userPasswordToVerify = user.userPassword;

              //     //

              //     final dynamic returnData = await Navigator.pushNamed(
              //         context, RoutePaths.user_verify_email_container,
              //         arguments: _apiStatus.data.userId);

              //     if (returnData != null && returnData is User) {
              //       final User user = returnData;

              //       print(user.userId);
              //       Navigator.of(context).pop();
              //     }
              //   } else {
              //     showDialog<dynamic>(
              //         context: context,
              //         builder: (BuildContext context) {
              //           return ErrorDialog(
              //             message: _apiStatus.message,
              //           );
              //         });
              //   }
              // } else {
              //   showDialog<dynamic>(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return ErrorDialog(
              //           message: Utils.getString(
              //               context, 'error_dialog__no_internet'),
              //         );
              //       });
              // }
            }
            //
            // } else {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //           message: Utils.getString(
            //               context, 'login__warning_agree_privacy'),
            //         );
            //       });
            // }
          },
        )
      );
  }
}
