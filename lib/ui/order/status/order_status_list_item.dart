import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/constant/ps_dimens.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_status.dart';

class OrderStatusListItem extends StatelessWidget {
  const OrderStatusListItem({
    Key key,
    @required this.transactionStatus,
    this.onTap,
  }) : super(key: key);

  final TransactionStatus transactionStatus;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: PsDimens.space52,
        margin: const EdgeInsets.only(top: PsDimens.space4),
        child: Padding(
          padding: const EdgeInsets.all(PsDimens.space16),
          child: Text(
            transactionStatus.title,
            textAlign: TextAlign.start,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
