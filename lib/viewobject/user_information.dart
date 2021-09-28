import 'package:quiver/core.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_object.dart';

class UserInformation extends PsObject<UserInformation> {
  UserInformation({
    this.userStatus,
  });
  String userStatus;

  @override
  bool operator ==(dynamic other) =>
      other is UserInformation && userStatus == other.userStatus;

  @override
  int get hashCode => hash2(userStatus.hashCode, userStatus.hashCode);

  @override
  String getPrimaryKey() {
    return userStatus;
  }

  @override
  UserInformation fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return UserInformation(
        userStatus: dynamicData['user_status'],
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['user_status'] = object.userStatus;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<UserInformation> fromMapList(List<dynamic> dynamicDataList) {
    final List<UserInformation> psAppVersionList = <UserInformation>[];

    if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          psAppVersionList.add(fromMap(json));
        }
      }
    }
    return psAppVersionList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<UserInformation> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (UserInformation data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
