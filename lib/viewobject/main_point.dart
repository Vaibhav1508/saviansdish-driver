import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_object.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/trips.dart';
import 'package:quiver/core.dart';

class MainPoint extends PsObject<MainPoint> {
  MainPoint({this.id, this.trips});

  String id;
  List<Trips> trips;

  @override
  bool operator ==(dynamic other) => other is MainPoint && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  List<MainPoint> fromMapList(List<dynamic> dynamicDataList) {
    final List<MainPoint> subCategoryList = <MainPoint>[];

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
  MainPoint fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return MainPoint(
        id: dynamicData['id'],
        trips: Trips().fromMapList(dynamicData['trips']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(MainPoint object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['trips'] = Trips().toMapList(object.trips);

      return data;
    } else {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>> toMapList(List<MainPoint> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (MainPoint data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
