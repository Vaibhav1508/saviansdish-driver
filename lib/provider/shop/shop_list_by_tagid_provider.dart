// import 'dart:async';

// import 'package:flutterrtdeliveryboyapp/api/common/ps_resource.dart';
// import 'package:flutterrtdeliveryboyapp/api/common/ps_status.dart';
// import 'package:flutterrtdeliveryboyapp/provider/common/ps_provider.dart';
// import 'package:flutterrtdeliveryboyapp/repository/shop_repository.dart';
// import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
// import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_value_holder.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutterrtdeliveryboyapp/viewobject/shop.dart';

// class ShopListByTagIdProvider extends PsProvider {
//   ShopListByTagIdProvider({@required ShopRepository repo, int limit = 0})
//       : super(repo, limit) {
//     _repo = repo;

//     print('ShopListByTagId Provider: $hashCode');

//     Utils.checkInternetConnectivity().then((bool onValue) {
//       isConnectedToInternet = onValue;
//     });

//     shopListStream = StreamController<PsResource<List<Shop>>>.broadcast();
//     subscription =
//         shopListStream.stream.listen((PsResource<List<Shop>> resource) {
//       updateOffset(resource.data.length);

//       _shopListByTagId = resource;

//       if (resource.status != PsStatus.BLOCK_LOADING &&
//           resource.status != PsStatus.PROGRESS_LOADING) {
//         isLoading = false;
//       }

//       if (!isDispose) {
//         notifyListeners();
//       }
//     });
//   }

//   StreamController<PsResource<List<Shop>>> shopListStream;

//   ShopRepository _repo;
//   PsValueHolder psValueHolder;

//   PsResource<List<Shop>> _shopListByTagId =
//       PsResource<List<Shop>>(PsStatus.NOACTION, '', <Shop>[]);

//   PsResource<List<Shop>> get shopListByTagId => _shopListByTagId;
//   StreamSubscription<PsResource<List<Shop>>> subscription;

//   @override
//   void dispose() {
//     //_repo.cate.close();
//     subscription.cancel();
//     shopListStream.close();
//     isDispose = true;
//     print('Shop Provider Dispose: $hashCode');
//     super.dispose();
//   }
// }
