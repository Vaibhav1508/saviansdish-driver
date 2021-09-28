import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_colors.dart';
import 'package:flutterrtdeliveryboyapp/provider/point/point_provider.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

class PolylinePage extends StatefulWidget {
  const PolylinePage({@required this.pointProvider, @required this.tranLatLng});
  final PointProvider pointProvider;
  final LatLng tranLatLng;

  @override
  _PolylinePageState createState() => _PolylinePageState();
}

List<LatLng> points = <LatLng>[];
LatLng firstPointStringFormat;
LatLng secPointStringFormat;
LatLng thirdPointStringFormat;
LatLng centerPointStringFormat;

class _PolylinePageState extends State<PolylinePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PointProvider>(
        builder: (BuildContext context, PointProvider provider, Widget child) {
      if (widget.pointProvider != null &&
          widget.pointProvider.mainPoint.data != null) {
        points = <LatLng>[];
        // centerPointStringFormat
        // for(int a=0; a< widget.pointProvider.mainPoint.data.trips.length; a++){
        //for(int b=0; b< widget.pointProvider.mainPoint.data.trips[0].legList.length; b++){
        if (widget.pointProvider.mainPoint.data.trips.isNotEmpty) {
          for (int c = 0;
              c <
                  widget.pointProvider.mainPoint.data.trips[0].legList[0]
                      .stepList.length;
              c++) {
            points.add(LatLng(
                widget.pointProvider.mainPoint.data.trips[0].legList[0]
                    .stepList[c].maneuver.locationList[1],
                widget.pointProvider.mainPoint.data.trips[0].legList[0]
                    .stepList[c].maneuver.locationList[0]));
          }
        }
        // }
        centerPointStringFormat = LatLng(
            widget
                .pointProvider
                .mainPoint
                .data
                .trips[0]
                .legList[0]
                .stepList[widget.pointProvider.mainPoint.data.trips[0]
                        .legList[0].stepList.length ~/
                    2]
                .maneuver
                .locationList[1],
            widget
                .pointProvider
                .mainPoint
                .data
                .trips[0]
                .legList[0]
                .stepList[widget.pointProvider.mainPoint.data.trips[0]
                        .legList[0].stepList.length ~/
                    2]
                .maneuver
                .locationList[0]);
      } else {
        points = <LatLng>[];
        points.add(widget.tranLatLng);
        centerPointStringFormat = widget.tranLatLng;
      }

      return Scaffold(
        body: Column(
          children: <Widget>[
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(centerPointStringFormat.latitude,
                      centerPointStringFormat.longitude),
                  zoom: 15.0,
                ),
                layers: <LayerOptions>[
                  TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: <String>['a', 'b', 'c']),
                  PolylineLayerOptions(
                    polylines: <Polyline>[
                      Polyline(
                          points: points,
                          strokeWidth: 3.0,
                          color: PsColors.mapDistanceColor),
                    ],
                  ),
                  MarkerLayerOptions(markers: <Marker>[
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: widget.tranLatLng,
                      builder: (BuildContext ctx) => Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.location_on,
                            color: PsColors.mainColor,
                          ),
                          iconSize: 45,
                          onPressed: () {},
                        ),
                      ),
                    )
                  ])
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
