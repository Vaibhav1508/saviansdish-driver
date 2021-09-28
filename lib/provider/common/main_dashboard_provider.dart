import 'package:flutter/material.dart';
import 'package:flutterrtdeliveryboyapp/provider/common/ps_provider.dart';
import 'package:geolocator/geolocator.dart';

class MainDashboardProvider extends PsProvider {
  MainDashboardProvider(this.currentIndex, this.appBarTitle, {int limit = 0})
      : super(null, limit) {
    print('Token Provider: $hashCode');
  }

  String appBarTitle;
  int currentIndex;
  Position currentUserLocation;

  String _appBarTitleCache;
  int _currentIndexCache;

  @override
  void dispose() {
    isDispose = true;
    print('Token Provider Dispose: $hashCode');
    super.dispose();
  }

  void updateUserLocation(Position currentUserLocation, bool mounted) {
    this.currentUserLocation = currentUserLocation;
    // if (mounted) {
    //   if (!isDispose) {
    //     notifyListeners();
    //   }
    // } else {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isDispose) {
        notifyListeners();
      }
    });
    // }
  }

  void updateIndex(int currentIndex, String appBarTitle, bool mounted) {
    this.appBarTitle = appBarTitle;
    this.currentIndex = currentIndex;

    _notify(mounted);
  }

  void _notify(bool mounted) {
    if (appBarTitle != _appBarTitleCache ||
        _currentIndexCache != currentIndex) {
      _appBarTitleCache = appBarTitle;
      _currentIndexCache = currentIndex;

      // if (mounted) {
      //   if (!isDispose) {
      //     notifyListeners();
      //   }
      // } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!isDispose) {
          notifyListeners();
        }
      });
      // }
    }
  }
}
