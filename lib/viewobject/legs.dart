import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_object.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/steps.dart';
import 'package:quiver/core.dart';

class Legs extends PsObject<Legs> {
  Legs({this.id, this.stepList});

  String id;
  List<Steps> stepList;

  @override
  bool operator ==(dynamic other) => other is Legs && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  List<Legs> fromMapList(List<dynamic> dynamicDataList) {
    final List<Legs> subCategoryList = <Legs>[];

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
  Legs fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Legs(
        id: dynamicData['id'],
        stepList: Steps().fromMapList(dynamicData['steps']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Legs object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['steps'] = Steps().toMapList(object.stepList);

      return data;
    } else {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Legs> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (Legs data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
