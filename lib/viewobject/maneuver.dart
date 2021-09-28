import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';

//this object is specific object
class Maneuver extends PsObject<Maneuver> {
  Maneuver({this.id, this.locationList});

  String id;
  // List<String> locationList;
  List<double> locationList = <double>[];
  // List<Map<double,double>> locationList;
  // List<Location> locationList;

  @override
  bool operator ==(dynamic other) => other is Maneuver && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  List<Maneuver> fromMapList(List<dynamic> dynamicDataList) {
    final List<Maneuver> subCategoryList = <Maneuver>[];

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
  Maneuver fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      // print(List<double>.from(dynamicData['location']));
      return Maneuver(
        // id: dynamicData['id'],
        // locationList : List<Map<double,double>>.from(dynamicData['location']),
        locationList: fromMapListObj(dynamicData['location']),
      );
    } else {
      return null;
    }
  }

  List<double> fromMapListObj(List<dynamic> dynamicDataList) {
    final List<double> subCategoryList = <double>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subCategoryList.add(dynamicData);
        }
      }
    }
    return subCategoryList;
  }

  @override
  Map<String, dynamic> toMap(Maneuver object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      // data['id'] = object.id;
      // data['location'] = List<Map<double,double>>.from(object.locationList);
      data['location'] = List<double>.from(object.locationList);

      return data;
    } else {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Maneuver> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (Maneuver data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
