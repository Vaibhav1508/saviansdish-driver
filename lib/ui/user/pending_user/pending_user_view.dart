import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_colors.dart';
import 'package:flutterrtdeliveryboyapp/constant/ps_dimens.dart';
import 'package:flutterrtdeliveryboyapp/provider/user/user_provider.dart';
import 'package:flutterrtdeliveryboyapp/ui/common/ps_ui_widget.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';

class PendingUserView extends StatefulWidget {
  const PendingUserView({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<PendingUserView>
    with SingleTickerProviderStateMixin {
  UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: PsDimens.space44),
        child: Stack(
          children: <Widget>[
            Container(
              color: PsColors.backgroundColor,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(bottom: PsDimens.space120),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    Utils.getString(context, 'user__wait_approve_title'),
                    style: Theme.of(context).textTheme.headline5.copyWith(),
                  ),
                  const SizedBox(
                    height: PsDimens.space16,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        PsDimens.space72, 0, PsDimens.space72, 0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                          Utils.getString(context, 'user__wait_approve_desc') +
                              '\n\n' +
                              psValueHolder.contactPhone +
                              '\n' +
                              psValueHolder.contactEmail +
                              '\n' +
                              psValueHolder.contactWebsite,
                          style:
                              Theme.of(context).textTheme.bodyText1.copyWith(),
                          textAlign: TextAlign.center),
                    ),
                  ),
                  Consumer<UserProvider>(
                    builder: (BuildContext context, UserProvider provider,
                        Widget child) {
                      return Visibility(
                        visible: PsStatus.NOACTION == provider.user.status ||
                            PsStatus.SUCCESS == provider.user.status ||
                            PsStatus.ERROR == provider.user.status,
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
                            if (!psValueHolder.isUserToLogin()) {
                              userProvider.getUser(psValueHolder.loginUserId);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Consumer<UserProvider>(builder:
                (BuildContext context, UserProvider provider, Widget child) {
              return PSProgressIndicator(userProvider.user.status);
            })
          ],
        ),
      ),
    );
  }
}

// widget.animationController.forward();
// return SingleChildScrollView(
//     child: Container(
//   color: PsColors.coreBackgroundColor,
//   height: MediaQuery.of(context).size.height - 40,
//   child: CustomScrollView(scrollDirection: Axis.vertical, slivers: <Widget>[
//     _ProfileDetailWidget(
//         animationController: widget.animationController,
//         animation: Tween<double>(begin: 0.0, end: 1.0).animate(
//           CurvedAnimation(
//             parent: widget.animationController,
//             curve: const Interval((1 / 4) * 2, 1.0,
//                 curve: Curves.fastOutSlowIn),
//           ),
//         ),
//         // onProfileSelected: widget.onProfileSelected,
//         userId: widget.userId),
//   ]),
// ));

// class _ProfileDetailWidget extends StatefulWidget {
//   const _ProfileDetailWidget(
//       {Key key,
//       this.animationController,
//       this.animation,
//       // @required this.onProfileSelected,
//       @required this.userId})
//       : super(key: key);

//   final AnimationController animationController;
//   final Animation<double> animation;
//   // final Function onProfileSelected;
//   final String userId;

//   @override
//   __ProfileDetailWidgetState createState() => __ProfileDetailWidgetState();
// }

// class __ProfileDetailWidgetState extends State<_ProfileDetailWidget> {
//   UserRepository userRepository;
//   PsValueHolder psValueHolder;
//   UserProvider provider;
//   @override
//   Widget build(BuildContext context) {
//     userRepository = Provider.of<UserRepository>(context);
//     psValueHolder = Provider.of<PsValueHolder>(context, listen: false);
//     provider = Provider.of<UserProvider>(context, listen: false);
//     return SliverToBoxAdapter(
//         child:
//             // ChangeNotifierProvider<UserProvider>(
//             //     lazy: false,
//             //     create: (BuildContext context) {
//             //       provider = UserProvider(
//             //           repo: userRepository, psValueHolder: psValueHolder);
//             //       if (provider.psValueHolder.loginUserId == null ||
//             //           provider.psValueHolder.loginUserId == '') {
//             //         provider.getUser(widget.userId);
//             //       } else {
//             //         provider.getUser(provider.psValueHolder.loginUserId);
//             //       }
//             //       return provider;
//             //     },
//             //     child: Consumer<UserProvider>(builder:
//             //         (BuildContext context, UserProvider provider, Widget child) {
//             // if (provider.user != null &&
//             //     provider.user.data != null &&
//             //     provider.user.data.userFlag != null) {
//             // provider.replaceIsDeliveryBoy(provider.user.data.userFlag);
//             // if (widget.onProfileSelected != null) {
//             //   widget.onProfileSelected(
//             //       provider.user.data.userId, provider.user.data.userFlag);
//             // }
//             // return
//             SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: PsDimens.space44),
//         child: Stack(
//           children: <Widget>[
//             Container(
//               color: PsColors.backgroundColor,
//               height: MediaQuery.of(context).size.height,
//               padding: const EdgeInsets.only(bottom: PsDimens.space120),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   const SizedBox(
//                     height: PsDimens.space8,
//                   ),
//                   Text(
//                     Utils.getString(context, 'user__wait_approve_title'),
//                     style: Theme.of(context).textTheme.headline5.copyWith(),
//                   ),
//                   const SizedBox(
//                     height: PsDimens.space16,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(
//                         PsDimens.space72, 0, PsDimens.space72, 0),
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                           Utils.getString(context, 'user__wait_approve_desc') +
//                               '\n\n' +
//                               provider.psValueHolder.contactPhone +
//                               '  ' +
//                               provider.psValueHolder.contactEmail +
//                               '  ' +
//                               provider.psValueHolder.contactWebsite,
//                           style:
//                               Theme.of(context).textTheme.bodyText1.copyWith(),
//                           textAlign: TextAlign.center),
//                     ),
//                   ),
//                   Visibility(
//                     visible: PsStatus.NOACTION == provider.user.status ||
//                         PsStatus.SUCCESS == provider.user.status ||
//                         PsStatus.ERROR == provider.user.status,
//                     child: InkWell(
//                       child: Container(
//                         height: PsDimens.space80,
//                         width: PsDimens.space80,
//                         child: Icon(
//                           Icons.refresh,
//                           color: PsColors.mainColor,
//                           size: PsDimens.space40,
//                         ),
//                       ),
//                       onTap: () {
//                         if (provider.psValueHolder.loginUserId == null ||
//                             provider.psValueHolder.loginUserId == '') {
//                           provider.getUser(widget.userId);
//                         } else {
//                           provider.getUser(provider.psValueHolder.loginUserId);
//                         }
//                         // provider.getUser(provider.psValueHolder.loginUserId);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             PSProgressIndicator(provider.user.status),
//           ],
//         ),
//       ),
//     )
//         // ;
//         // } else {
//         //   return Container();
//         // }
//         // })),
//         );
//   }
// }
