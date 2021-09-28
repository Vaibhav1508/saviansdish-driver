import 'dart:core';
import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_object.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/shop.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/transaction_status.dart';

class TransactionHeader extends PsObject<TransactionHeader> {
  TransactionHeader(
      {this.id,
      this.userId,
      this.shopId,
      this.subTotalAmount,
      this.discountAmount,
      this.balanceAmount,
      this.cuponDiscountAmount,
      this.taxAmount,
      this.taxPercent,
      this.shippingAmount,
      this.shippingTaxPercent,
      this.totalItemAmount,
      this.totalItemCount,
      this.contactName,
      this.contactPhone,
      this.contactAddress,
      this.paymentMethod,
      this.addedDate,
      this.addedUserId,
      this.updatedDate,
      this.updatedUserId,
      this.updatedFlag,
      this.transStatusId,
      this.paymentStatusId,
      this.deliveryBoyId,
      this.currencySymbol,
      this.currencyShortForm,
      this.transCode,
      this.razorId,
      this.transLat,
      this.transLng,
      this.addedDateStr,
      this.transactionStatus,
      this.shop});

  String id;
  String userId;
  String shopId;
  String subTotalAmount;
  String discountAmount;
  String balanceAmount;
  String cuponDiscountAmount;
  String taxAmount;
  String taxPercent;
  String shippingAmount;
  String shippingTaxPercent;
  String totalItemAmount;
  String totalItemCount;
  String contactName;
  String contactPhone;
  String contactAddress;
  String paymentMethod;
  String addedDate;
  String addedUserId;
  String updatedDate;
  String updatedUserId;
  String updatedFlag;
  String transStatusId;
  String paymentStatusId;
  String deliveryBoyId;
  String currencySymbol;
  String currencyShortForm;
  String transCode;
  String razorId;
  String transLat;
  String transLng;
  String addedDateStr;
  TransactionStatus transactionStatus;
  Shop shop;

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  TransactionHeader fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return TransactionHeader(
        id: dynamicData['id'],
        userId: dynamicData['user_id'],
        shopId: dynamicData['shop_id'],
        subTotalAmount: dynamicData['sub_total_amount'],
        discountAmount: dynamicData['discount_amount'],
        balanceAmount: dynamicData['balance_amount'],
        taxAmount: dynamicData['tax_amount'],
        taxPercent: dynamicData['tax_percent'],
        shippingAmount: dynamicData['shipping_amount'],
        shippingTaxPercent: dynamicData['shipping_tax_percent'],
        totalItemAmount: dynamicData['total_item_amount'],
        totalItemCount: dynamicData['total_item_count'],
        contactName: dynamicData['contact_name'],
        cuponDiscountAmount: dynamicData['coupon_discount_amount'],
        contactPhone: dynamicData['contact_phone'],
        contactAddress: dynamicData['contact_address'],
        paymentMethod: dynamicData['payment_method'],
        addedDate: dynamicData['added_date'],
        addedUserId: dynamicData['added_user_id'],
        updatedDate: dynamicData['updated_date'],
        updatedUserId: dynamicData['updated_user_id'],
        updatedFlag: dynamicData['updated_flag'],
        transStatusId: dynamicData['trans_status_id'],
        paymentStatusId: dynamicData['payment_status_id'],
        deliveryBoyId: dynamicData['delivery_boy_id'],
        currencySymbol: dynamicData['currency_symbol'],
        currencyShortForm: dynamicData['currency_short_form'],
        transCode: dynamicData['trans_code'],
        razorId: dynamicData['razor_id'],
        transLat: dynamicData['trans_lat'],
        transLng: dynamicData['trans_lng'],
        addedDateStr: dynamicData['added_date_str'],
        transactionStatus:
            TransactionStatus().fromMap(dynamicData['transaction_status']),
        shop: Shop().fromMap(dynamicData['shop']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['user_id'] = object.userId;
      data['shop_id'] = object.shopId;
      data['sub_total_amount'] = object.subTotalAmount;
      data['discount_amount'] = object.discountAmount;
      data['balance_amount'] = object.balanceAmount;
      data['coupon_discount_amount'] = object.cuponDiscountAmount;
      data['tax_amount'] = object.taxAmount;
      data['tax_percent'] = object.taxPercent;
      data['shipping_amount'] = object.shippingAmount;
      data['shipping_tax_percent'] = object.shippingTaxPercent;
      data['total_item_amount'] = object.totalItemAmount;
      data['total_item_count'] = object.totalItemCount;
      data['contact_name'] = object.contactName;
      data['contact_phone'] = object.contactPhone;
      data['contact_address'] = object.contactAddress;
      data['payment_method'] = object.paymentMethod;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedDate;
      data['updated_user_id'] = object.updatedUserId;
      data['updated_flag'] = object.updatedFlag;
      data['trans_status_id'] = object.transStatusId;
      data['payment_status_id'] = object.paymentStatusId;
      data['delivery_boy_id'] = object.deliveryBoyId;
      data['currency_symbol'] = object.currencySymbol;
      data['currency_short_form'] = object.currencyShortForm;
      data['trans_code'] = object.transCode;
      data['razor_id'] = object.razorId;
      data['trans_lat'] = object.transLat;
      data['trans_lng'] = object.transLng;
      data['added_date_str'] = object.addedDateStr;
      data['transaction_status'] =
          TransactionStatus().toMap(object.transactionStatus);
      data['shop'] =
          Shop().toMap(object.shop);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<TransactionHeader> fromMapList(List<dynamic> dynamicDataList) {
    final List<TransactionHeader> subCategoryList = <TransactionHeader>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subCategoryList.add(fromMap(dynamicData));
        }
      }
    }
    return subCategoryList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<TransactionHeader> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (TransactionHeader data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
