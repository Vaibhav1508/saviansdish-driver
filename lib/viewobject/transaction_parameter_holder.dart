import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_holder.dart';

class TransactionParameterHolder extends PsHolder<dynamic> {
  TransactionParameterHolder() {
    type = '';
  }

  String type;

  TransactionParameterHolder getPendingOrderParameterHolder() {
    type = 'pending';

    return this;
  }

  TransactionParameterHolder getCompletedOrderParameterHolder() {
    type = 'completed';

    return this;
  }

  TransactionParameterHolder resetParameterHolder() {
    type = '';

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['searchterm'] = type;
    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    type = '';

    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (type != '') {
      result += type + ':';
    }
    return result;
  }
}
