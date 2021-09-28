import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_colors.dart';
import 'package:flutterrtdeliveryboyapp/constant/ps_dimens.dart';
import 'package:flutterrtdeliveryboyapp/provider/user/user_provider.dart';
import 'package:flutterrtdeliveryboyapp/ui/common/ps_ui_widget.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';

class RejectUserView extends StatefulWidget {
  const RejectUserView({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<RejectUserView>
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
                    Utils.getString(context, 'user__reject_title'),
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
                          Utils.getString(context, 'user__reject_desc') +
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
                            PsStatus.SUCCESS == userProvider.user.status ||
                            PsStatus.ERROR == userProvider.user.status,
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
