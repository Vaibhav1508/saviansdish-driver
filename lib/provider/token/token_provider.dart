import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_resource.dart';
import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
import 'package:flutterrtdeliveryboyapp/provider/common/ps_provider.dart';
import 'package:flutterrtdeliveryboyapp/repository/token_repository.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/api_status.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_value_holder.dart';

class TokenProvider extends PsProvider {
  TokenProvider(
      {@required TokenRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    // _psApiService = psApiService;
    print('Token Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    tokenDataListStream = StreamController<PsResource<ApiStatus>>.broadcast();
    subscription =
        tokenDataListStream.stream.listen((PsResource<ApiStatus> resource) {
      _tokenData = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  PsResource<ApiStatus> _tokenData =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);

  PsResource<ApiStatus> get tokenData => _tokenData;
  StreamSubscription<PsResource<ApiStatus>> subscription;
  StreamController<PsResource<ApiStatus>> tokenDataListStream;

  TokenRepository _repo;
  PsValueHolder psValueHolder;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Token Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> getToken(String shopId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _tokenData =
        await _repo.getToken(shopId, isConnectedToInternet, PsStatus.SUCCESS);

    return _tokenData;
  }
}
