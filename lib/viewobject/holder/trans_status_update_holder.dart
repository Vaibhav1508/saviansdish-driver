import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_holder.dart';
import 'package:flutter/cupertino.dart';

class TransStatusUpdateHolder extends PsHolder<TransStatusUpdateHolder> {
  TransStatusUpdateHolder(
      {@required this.transactionsHeaderId, @required this.transStatusId});

  final String transactionsHeaderId;
  final String transStatusId;

  @override
  Map<dynamic, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['transactions_header_id'] = transactionsHeaderId;
    map['trans_status_id'] = transStatusId;

    return map;
  }

  @override
  TransStatusUpdateHolder fromMap(dynamic dynamicData) {
    return TransStatusUpdateHolder(
      transactionsHeaderId: dynamicData['transactions_header_id'],
      transStatusId: dynamicData['trans_status_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (transactionsHeaderId != '') {
      key += transactionsHeaderId;
    }
    if (transStatusId != '') {
      key += transStatusId;
    }
    return key;
  }
}
