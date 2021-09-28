import 'package:quiver/core.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_object.dart';

class DeliBoyVersion extends PsObject<DeliBoyVersion> {
  DeliBoyVersion(
      {this.deliBoyVersionNo,
      this.deliBoyVersionForceUpdate,
      this.deliBoyVersionTitle,
      this.deliBoyVersionMessage,
      this.deliBoyVersionNeedClearData});
  String deliBoyVersionNo;
  String deliBoyVersionForceUpdate;
  String deliBoyVersionTitle;
  String deliBoyVersionMessage;
  String deliBoyVersionNeedClearData;

  @override
  bool operator ==(dynamic other) =>
      other is DeliBoyVersion && deliBoyVersionNo == other.deliBoyVersionNo;

  @override
  int get hashCode =>
      hash2(deliBoyVersionNo.hashCode, deliBoyVersionNo.hashCode);

  @override
  String getPrimaryKey() {
    return deliBoyVersionNo;
  }

  @override
  DeliBoyVersion fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return DeliBoyVersion(
          deliBoyVersionNo: dynamicData['deli_boy_version_no'],
          deliBoyVersionForceUpdate:
              dynamicData['deli_boy_version_force_update'],
          deliBoyVersionTitle: dynamicData['deli_boy_version_title'],
          deliBoyVersionMessage: dynamicData['deli_boy_version_message'],
          deliBoyVersionNeedClearData:
              dynamicData['deli_boy_version_need_clear_data']);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['deli_boy_version_no'] = object.deliBoyVersionNo;
      data['deli_boy_version_force_update'] = object.deliBoyVersionForceUpdate;
      data['deli_boy_version_title'] = object.deliBoyVersionTitle;
      data['deli_boy_version_message'] = object.deliBoyVersionMessage;
      data['deli_boy_version_need_clear_data'] =
          object.deliBoyVersionNeedClearData;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<DeliBoyVersion> fromMapList(List<dynamic> dynamicDataList) {
    final List<DeliBoyVersion> deliBoyVersionList = <DeliBoyVersion>[];

    if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          deliBoyVersionList.add(fromMap(json));
        }
      }
    }
    return deliBoyVersionList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<DeliBoyVersion> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (DeliBoyVersion data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
