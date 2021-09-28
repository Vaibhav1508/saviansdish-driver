import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_holder.dart';
import 'package:flutter/cupertino.dart';

class PaymentStatusHolder extends PsHolder<PaymentStatusHolder> {
  PaymentStatusHolder(
      {@required this.transactionsHeaderId, @required this.paymentStatusId});

  final String transactionsHeaderId;
  final String paymentStatusId;

  @override
  Map<dynamic, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['transactions_header_id'] = transactionsHeaderId;
    map['payment_status_id'] = paymentStatusId;

    return map;
  }

  @override
  PaymentStatusHolder fromMap(dynamic dynamicData) {
    return PaymentStatusHolder(
      transactionsHeaderId: dynamicData['transactions_header_id'],
      paymentStatusId: dynamicData['payment_status_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (transactionsHeaderId != '') {
      key += transactionsHeaderId;
    }
    if (paymentStatusId != '') {
      key += paymentStatusId;
    }
    return key;
  }
}
