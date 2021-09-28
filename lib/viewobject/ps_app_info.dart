import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_object.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/delete_object.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/deli_boy_version.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/ps_app_version.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/user_information.dart';

class PSAppInfo extends PsObject<PSAppInfo> {
  PSAppInfo(
      {this.psAppVersion,
      this.deliBoyVersion,
      this.userInfo,
      this.deleteObject,
      this.enableComment,
      this.enableReview,
      this.contactPhone,
      this.contactEmail,
      this.contactWebsite});
  PSAppVersion psAppVersion;
  DeliBoyVersion deliBoyVersion;
  List<DeleteObject> deleteObject;
  UserInformation userInfo;
  String enableComment;
  String enableReview;
  String contactPhone;
  String contactEmail;
  String contactWebsite;

  @override
  String getPrimaryKey() {
    return '';
  }

  @override
  PSAppInfo fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return PSAppInfo(
        psAppVersion: PSAppVersion().fromMap(dynamicData['version']),
        deliBoyVersion:
            DeliBoyVersion().fromMap(dynamicData['deliboy_version']),
        userInfo: UserInformation().fromMap(dynamicData['user_info']),
        deleteObject: DeleteObject().fromMapList(dynamicData['delete_history']),
        enableComment: dynamicData['enable_comment'],
        enableReview: dynamicData['enable_review'],
        contactPhone: dynamicData['contact_phone'],
        contactEmail: dynamicData['contact_email'],
        contactWebsite: dynamicData['contact_website'],
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['version'] = PSAppVersion().fromMap(object.psAppVersion);
      data['deliboy_version'] = DeliBoyVersion().fromMap(object.deliBoyVersion);
      data['user_info'] = UserInformation().fromMap(object.userInfo);
      data['delete_history'] = object.deleteObject.toList();
      data['enable_comment'] = object.enableComment;
      data['enable_review'] = object.enableReview;
      data['contact_phone'] = object.contactPhone;
      data['contact_email'] = object.contactEmail;
      data['contact_website'] = object.contactWebsite;

      return data;
    } else {
      return null;
    }
  }

  @override
  List<PSAppInfo> fromMapList(List<dynamic> dynamicDataList) {
    final List<PSAppInfo> psAppInfoList = <PSAppInfo>[];

    if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          psAppInfoList.add(fromMap(json));
        }
      }
    }
    return psAppInfoList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<dynamic> objectList) {
    final List<dynamic> dynamicList = <dynamic>[];
    if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
    }

    return dynamicList;
  }
}
