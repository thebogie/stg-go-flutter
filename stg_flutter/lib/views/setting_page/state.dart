import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:stg_flutter/globalbasestate/store.dart';

class SettingPageState implements Cloneable<SettingPageState> {
  AnimationController pageAnimation;
  AnimationController userEditAnimation;
  FirebaseUser user;
  String userName;
  String photoUrl;
  String userPanelPhotoUrl;
  String phone;
  String version;
  TextEditingController userNameController;
  TextEditingController photoController;
  TextEditingController phoneController;
  bool adultSwitchValue;
  bool isEditProfile;
  bool uploading;
  bool loading;
  double cachedSize;
  @override
  SettingPageState clone() {
    return SettingPageState()
      ..pageAnimation = pageAnimation
      ..userEditAnimation = userEditAnimation
      ..adultSwitchValue = adultSwitchValue
      ..isEditProfile = isEditProfile
      ..cachedSize = cachedSize
      ..user = user
      ..userName = userName
      ..phone = phone
      ..photoUrl = photoUrl
      ..userPanelPhotoUrl = userPanelPhotoUrl
      ..userNameController = userNameController
      ..phoneController = phoneController
      ..photoController = photoController
      ..uploading = uploading
      ..loading = loading
      ..version = version;
  }
}

SettingPageState initState(Map<String, dynamic> args) {
  SettingPageState state = SettingPageState();
  final user = GlobalStore.store.getState().user;
  if (user != null) {
    state.user = user;
    state.userName = user.displayName;
    state.phone = user.phoneNumber;
    state.photoUrl = user.photoUrl;
    state.userPanelPhotoUrl = user.photoUrl;
  }
  state.adultSwitchValue = false;
  state.isEditProfile = false;
  state.uploading = false;
  state.loading = false;
  state.cachedSize = 0;
  return state;
}
