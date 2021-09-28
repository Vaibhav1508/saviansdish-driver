import 'package:flutter_map/flutter_map.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_colors.dart';
import 'package:flutterrtdeliveryboyapp/config/ps_config.dart';
import 'package:flutterrtdeliveryboyapp/constant/ps_constants.dart';
import 'package:flutterrtdeliveryboyapp/constant/ps_dimens.dart';
import 'package:flutterrtdeliveryboyapp/provider/shop_info/shop_info_provider.dart';
import 'package:flutterrtdeliveryboyapp/ui/common/ps_ui_widget.dart';
import 'package:flutterrtdeliveryboyapp/ui/common/smooth_star_rating_widget.dart';
import 'package:flutterrtdeliveryboyapp/ui/shop_info/address_tile_view.dart';
import 'package:flutterrtdeliveryboyapp/ui/shop_info/contact_us_tile_view.dart';
import 'package:flutterrtdeliveryboyapp/utils/utils.dart';
import 'package:flutterrtdeliveryboyapp/viewobject/shop_info.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopInfoView extends StatefulWidget {
  const ShopInfoView(
      {Key key,
      @required this.shopId,
      @required this.shopInfoProvider,
      this.animationController,
      this.animation})
      : super(key: key);

  final String shopId;
  final ShopInfoProvider shopInfoProvider;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  _ShopInfoViewState createState() => _ShopInfoViewState();
}

class _ShopInfoViewState extends State<ShopInfoView> {
  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();

    return SliverToBoxAdapter(
        child: AnimatedBuilder(
            animation: widget.animationController,
            child: Column(
              children: <Widget>[
                _ShopInfoViewWidget(
                    shopId: widget.shopId,
                    shopInfoProvider: widget.shopInfoProvider),
                // _CustomerReviewListViewWidget(
                //   shopId: widget.shopId,
                //   shopInfoProvider: widget.shopInfoProvider,
                // )
              ],
            ),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                   transform: Matrix4.translationValues(
                      0.0, 30 * (1.0 - widget.animation.value), 0.0),
            child: child
              // } else {
              //   return Container();
              // }
              // })
            )
          );
        })
      );
  }
}

class _ShopInfoViewWidget extends StatefulWidget {
  const _ShopInfoViewWidget({
    Key key,
    @required this.shopId,
    @required this.shopInfoProvider,
  }) : super(key: key);

  final String shopId;
  final ShopInfoProvider shopInfoProvider;

  @override
  __ShopInfoViewWidgetState createState() => __ShopInfoViewWidgetState();
}

class __ShopInfoViewWidgetState extends State<_ShopInfoViewWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConfig.showAdMob) {
        setState(() {});
      }
    });
  }

  LatLng _latlng;
  final double zoom = 15;
  final MapController mapController = MapController();
  @override
  Widget build(BuildContext context) {
    _latlng = LatLng(double.parse(widget.shopInfoProvider.shopInfo.data.lat),
        double.parse(widget.shopInfoProvider.shopInfo.data.lng));
    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    return Container(
      color: PsColors.baseColor,
      child: Column(
        children: <Widget>[
          _HeaderBoxWidget(
              shopInfo: widget.shopInfoProvider.shopInfo.data,
              shopInfoProvider: widget.shopInfoProvider),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: Container(
              height: 250,
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center:
                      _latlng, //LatLng(51.5, -0.09), //LatLng(45.5231, -122.6765),
                  zoom: zoom, //10.0,
                  // onTap: (LatLng latLngr) {
                  //   FocusScope.of(context).requestFocus(FocusNode());
                  // }
                ),
                layers: <LayerOptions>[
                  TileLayerOptions(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayerOptions(markers: <Marker>[
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _latlng,
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
          ),
          AddressTileView(
            shopInfo: widget.shopInfoProvider.shopInfo.data,
          ),
          ContactUsTileView(
            shopInfo: widget.shopInfoProvider.shopInfo.data,
          ),
        ],
      ),
    );
  }
}

class _HeaderBoxWidget extends StatefulWidget {
  const _HeaderBoxWidget({
    Key key,
    @required this.shopInfo,
    @required this.shopInfoProvider,
  }) : super(key: key);

  final ShopInfoProvider shopInfoProvider;
  final ShopInfo shopInfo;

  @override
  __HeaderBoxWidgetState createState() => __HeaderBoxWidgetState();
}

class __HeaderBoxWidgetState extends State<_HeaderBoxWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.shopInfo != null) {
      return Container(
        margin: const EdgeInsets.all(PsDimens.space12),
        decoration: BoxDecoration(
          color: PsColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(PsDimens.space16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.shopInfo.name,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(height: PsDimens.space8),
                    Row(
                      children: <Widget>[
                        Text(
                          '\$',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: widget.shopInfo.priceLevel ==
                                          PsConst.PRICE_LOW ||
                                      widget.shopInfo.priceLevel ==
                                          PsConst.PRICE_MEDIUM ||
                                      widget.shopInfo.priceLevel ==
                                          PsConst.PRICE_HIGH
                                  ? PsColors.priceLevelColor
                                  : PsColors.grey),
                          maxLines: 2,
                        ),
                        Text(
                          '\$',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: widget.shopInfo.priceLevel ==
                                          PsConst.PRICE_MEDIUM ||
                                      widget.shopInfo.priceLevel ==
                                          PsConst.PRICE_HIGH
                                  ? PsColors.priceLevelColor
                                  : PsColors.grey),
                          maxLines: 2,
                        ),
                        Text(
                          '\$',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: widget.shopInfo.priceLevel ==
                                      PsConst.PRICE_HIGH
                                  ? PsColors.priceLevelColor
                                  : PsColors.grey),
                          maxLines: 2,
                        ),
                        const SizedBox(width: PsDimens.space8),
                        Text(
                          widget.shopInfo.highlightedInfo,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyText1.copyWith(),
                          maxLines: 2,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: PsDimens.space12,
                    ),
                    Divider(
                      height: PsDimens.space1,
                      color: PsColors.mainColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: PsDimens.space16, bottom: PsDimens.space4),
                      child: _HeaderRatingWidget(
                        shopInfo: widget.shopInfo,
                        shopInfoProvider: widget.shopInfoProvider,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class _HeaderRatingWidget extends StatefulWidget {
  const _HeaderRatingWidget(
      {Key key, @required this.shopInfo, @required this.shopInfoProvider})
      : super(key: key);

  final ShopInfo shopInfo;
  final ShopInfoProvider shopInfoProvider;

  @override
  __HeaderRatingWidgetState createState() => __HeaderRatingWidgetState();
}

class __HeaderRatingWidgetState extends State<_HeaderRatingWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.shopInfo != null && widget.shopInfo.ratingDetail != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () async {},
            child: SmoothStarRating(
                key: Key(widget.shopInfo.ratingDetail.totalRatingValue),
                rating:
                    double.parse(widget.shopInfo.ratingDetail.totalRatingValue),
                allowHalfRating: false,
                starCount: 5,
                isReadOnly: true,
                size: PsDimens.space16,
                color: PsColors.ratingColor,
                borderColor: PsColors.grey.withAlpha(100),
                onRated: (double v) async {},
                spacing: 0.0),
          ),
          const SizedBox(
            height: PsDimens.space10,
          ),
          GestureDetector(
              onTap: () async {},
              child: (widget.shopInfo.overallRating != null && widget.shopInfo.overallRating != '0')
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.shopInfo.ratingDetail.totalRatingValue ?? '',
                          textAlign: TextAlign.left,
                          style:
                              Theme.of(context).textTheme.bodyText2.copyWith(),
                        ),
                        const SizedBox(
                          width: PsDimens.space4,
                        ),
                        Text(
                          '${Utils.getString(context, 'product_detail__out_of_five_stars')}(' +
                              widget.shopInfo.ratingDetail.totalRatingCount +
                              ' ${Utils.getString(context, 'product_detail__reviews')})',
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyText1.copyWith(),
                        ),
                      ],
                    )
                  : Text(
                      Utils.getString(context, 'product_detail__no_rating'))),
          const SizedBox(
            height: PsDimens.space16,
          ),
          Text(
            widget.shopInfo.description,
            style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.4),
          )
        ],
      );
    } else {
      return Container();
    }
  }
}

class ImageAndTextWidget extends StatelessWidget {
  const ImageAndTextWidget({
    Key key,
    @required this.data,
  }) : super(key: key);

  final ShopInfo data;
  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space4,
    );

    final Widget _imageWidget = PsNetworkImage(
      photoKey: '',
      defaultPhoto: data.defaultPhoto,
      width: 50,
      height: 50,
      boxfit: BoxFit.cover,
      onTap: () {},
    );

    return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space16,
            right: PsDimens.space16,
            top: PsDimens.space16),
        child: Row(
          children: <Widget>[
            _imageWidget,
            const SizedBox(
              width: PsDimens.space12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.name,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: PsColors.mainColor,
                        ),
                  ),
                  _spacingWidget,
                  InkWell(
                    child: Text(
                      data.aboutPhone1,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(),
                    ),
                    onTap: () async {
                      if (await canLaunch('tel://${data.aboutPhone1}')) {
                        await launch('tel://${data.aboutPhone1}');
                      } else {
                        throw 'Could not Call Phone Number 1';
                      }
                    },
                  ),
                  _spacingWidget,
                  Row(
                    children: <Widget>[
                      Container(
                          child: const Icon(
                        Icons.email,
                      )),
                      const SizedBox(
                        width: PsDimens.space8,
                      ),
                      InkWell(
                        child: Text(data.codEmail,
                            style: Theme.of(context).textTheme.bodyText2),
                        onTap: () async {
                          if (await canLaunch(
                              'mailto:teamps.is.cool@gmail.com')) {
                            await launch('mailto:teamps.is.cool@gmail.com');
                          } else {
                            throw 'Could not launch teamps.is.cool@gmail.com';
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

// class _CustomerReviewListViewWidget extends StatelessWidget {
//   const _CustomerReviewListViewWidget({
//     Key key,
//     @required this.shopId,
//     @required this.shopInfoProvider,
//   }) : super(key: key);

//   final String shopId;
//   final ShopInfoProvider shopInfoProvider;
//   @override
//   Widget build(BuildContext context) {
//     dynamic result;
//     if (shopRatingProvider.ratingList != null &&
//         shopRatingProvider.ratingList.data != null) {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: PsDimens.space44),
//         child: Column(
//           children: <Widget>[
//             _CustomerReviewHeaderWidget(viewAllClicked: () async {
//               result = await Navigator.pushNamed(
//                   context, RoutePaths.shopRatingList,
//                   arguments: shopId);

//               if (result != null && result) {
//                 shopRatingProvider.refreshShopRatingList(shopId);
//                 shopInfoProvider.loadShopInfo(shopId);
//               }
//             }),
//             CustomScrollView(
//                 physics: const NeverScrollableScrollPhysics(),
//                 scrollDirection: Axis.vertical,
//                 shrinkWrap: true,
//                 slivers: <Widget>[
//                   SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (BuildContext context, int index) {
//                         if (shopRatingProvider.ratingList.data != null ||
//                             shopRatingProvider.ratingList.data.isNotEmpty) {
//                           return CustomerReviewListItem(
//                             shopRating:
//                                 shopRatingProvider.ratingList.data[index],
//                             onTap: () {
//                               Navigator.pushNamed(
//                                   context, RoutePaths.transactionDetail,
//                                   arguments: shopRatingProvider
//                                       .ratingList.data[index]);
//                             },
//                           );
//                         } else {
//                           return null;
//                         }
//                       },
//                       childCount: shopRatingProvider.ratingList.data.length,
//                     ),
//                   ),
//                 ]),
//           ],
//         ),
//       );
//     } else {
//       return Container();
//     }
//   }
// }

class _CustomerReviewHeaderWidget extends StatefulWidget {
  const _CustomerReviewHeaderWidget({
    Key key,
    @required this.viewAllClicked,
  }) : super(key: key);
  final Function viewAllClicked;
  @override
  __CustomerReviewHeaderWidgetState createState() =>
      __CustomerReviewHeaderWidgetState();
}

class __CustomerReviewHeaderWidgetState
    extends State<_CustomerReviewHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.viewAllClicked,
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space4,
            left: PsDimens.space20,
            right: PsDimens.space20,
            bottom: PsDimens.space4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Text(
                  Utils.getString(context, 'rating_list__customer_reviews'),
                  style: Theme.of(context).textTheme.subtitle1),
            ),
            Text(
              Utils.getString(context, 'customer_review__view_all'),
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: PsColors.mainColor),
            ),
          ],
        ),
      ),
    );
  }
}
