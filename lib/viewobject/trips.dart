import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_object.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/legs.dart';
import 'package:quiver/core.dart';

class Trips extends PsObject<Trips> {
  Trips({this.id, this.legList});

  String id;
  List<Legs> legList;

  @override
  bool operator ==(dynamic other) => other is Trips && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  List<Trips> fromMapList(List<dynamic> dynamicDataList) {
    final List<Trips> subCategoryList = <Trips>[];

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
  Trips fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Trips(
        // id: dynamicData['id'],
        legList: Legs().fromMapList(dynamicData['legs']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Trips object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      // data['id'] = object.id;
      data['legs'] = Legs().toMapList(object.legList);

      return data;
    } else {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Trips> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (Trips data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
