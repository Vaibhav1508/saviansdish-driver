import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_colors.dart';
import 'package:flutterrtdeliveryboyapp/constant/ps_dimens.dart';
import 'package:flutterrtdeliveryboyapp/provider/common/main_dashboard_provider.dart';
import 'package:flutterrtdeliveryboyapp/provider/shop_info/shop_info_provider.dart';
import 'package:flutterrtdeliveryboyapp/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

class CurrentLocationWidget extends StatefulWidget {
  const CurrentLocationWidget(
      {Key key,

      /// If set, enable the FusedLocationProvider on Android
      @required this.androidFusedLocation,
      @required this.isShowAddress,
      this.textEditingController,
      @required this.shopInfoProvider})
      : super(key: key);

  final bool androidFusedLocation;
  final bool isShowAddress;
  final TextEditingController textEditingController;
  final ShopInfoProvider shopInfoProvider;

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget> {
  Position _currentPosition;
  String address = '';
  bool bindDataFirstTime = true;
  final MapController mapController = MapController();
  MainDashboardProvider _mainDashboardProvider;
  @override
  void initState() {
    super.initState();
    _initCurrentLocation();

    _mainDashboardProvider =
        Provider.of<MainDashboardProvider>(context, listen: false);

    if (_mainDashboardProvider.currentUserLocation != null) {
      _currentPosition = _mainDashboardProvider.currentUserLocation;

      loadAddress(false);
    }
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  dynamic loadAddress(bool isReload) async {
    if (_currentPosition != null) {
      _mainDashboardProvider.updateUserLocation(_currentPosition, mounted);
      if (widget.shopInfoProvider != null) {
        widget.shopInfoProvider.currentLatlng ??=
            LatLng(_currentPosition.latitude, _currentPosition.longitude);
      }
      final List<Address> addresses = await Geocoder.local
          .findAddressesFromCoordinates(Coordinates(
              _currentPosition.latitude, _currentPosition.longitude));
      final Address first = addresses.first;
      address = '${first.addressLine}';

      if (mounted) {
        setState(() {
          widget.textEditingController.text = address;
        });
      } else {
        widget.textEditingController.text = address;
      }
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  dynamic _initCurrentLocation() {
    Geolocator()
      ..forceAndroidLocationManager = !widget.androidFusedLocation
      ..getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).then((Position position) {
        if (mounted) {
          if (position != _currentPosition) {
            _currentPosition = position;
            loadAddress(true);
          }
        }
      }).catchError((Object e) {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isShowAddress) {
      return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space8,
            right: PsDimens.space8,
            bottom: PsDimens.space8),
        child: Card(
          elevation: 0.0,
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          color: PsColors.baseLightColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      (widget.textEditingController.text == '')
                          ? Utils.getString(context, 'dashboard__open_gps')
                          : widget.textEditingController.text,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          letterSpacing: 0.8, fontSize: 16, height: 1.3),
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    height: PsDimens.space44,
                    width: PsDimens.space44,
                    child: Icon(
                      Icons.gps_fixed,
                      color: PsColors.iconColor,
                      size: PsDimens.space20,
                    ),
                  ),
                  onTap: () {
                    if (widget.shopInfoProvider.currentLatlng == null) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmDialogView(
                                description: Utils.getString(
                                    context, 'map_pin__open_gps'),
                                leftButtonText: Utils.getString(context,
                                    'home__logout_dialog_cancel_button'),
                                rightButtonText: Utils.getString(
                                    context, 'home__logout_dialog_ok_button'),
                                onAgreeTap: () async {
                                  Navigator.pop(context);
                                });
                          });
                    } else {
                      loadAddress(true);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
