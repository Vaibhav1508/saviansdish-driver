import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class CompletedOrderListHolder extends PsHolder<CompletedOrderListHolder> {
  CompletedOrderListHolder({@required this.deliveryBoyId});

  final String deliveryBoyId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['delivery_boy_id'] = deliveryBoyId;

    return map;
  }

  @override
  CompletedOrderListHolder fromMap(dynamic dynamicData) {
    return CompletedOrderListHolder(
      deliveryBoyId: dynamicData['delivery_boy_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (deliveryBoyId != '') {
      key += deliveryBoyId;
    }
    return key;
  }
}
