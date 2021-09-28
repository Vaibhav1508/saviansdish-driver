import 'package:flutterrtdeliveryboyapp/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class ProfileUpdateParameterHolder
    extends PsHolder<ProfileUpdateParameterHolder> {
  ProfileUpdateParameterHolder(
      {@required this.userId,
      @required this.userName,
      @required this.userEmail,
      @required this.userPhone,
      @required this.userAboutMe});

  final String userId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String userAboutMe;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['user_id'] = userId;
    map['user_name'] = userName;
    map['user_email'] = userEmail;
    map['user_phone'] = userPhone;
    map['user_about_me'] = userAboutMe;

    return map;
  }

  @override
  ProfileUpdateParameterHolder fromMap(dynamic dynamicData) {
    return ProfileUpdateParameterHolder(
      userId: dynamicData['user_id'],
      userName: dynamicData['user_name'],
      userEmail: dynamicData['user_email'],
      userPhone: dynamicData['user_phone'],
      userAboutMe: dynamicData['user_about_me'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId;
    }
    if (userName != '') {
      key += userName;
    }

    if (userEmail != '') {
      key += userEmail;
    }
    if (userPhone != '') {
      key += userPhone;
    }

    if (userAboutMe != '') {
      key += userAboutMe;
    }
    return key;
  }
}
