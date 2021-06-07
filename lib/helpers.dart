import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


Widget loadAdmobBanner() {
  if(!kIsWeb){
  final banner = AdmobBanner(
    adUnitId: kAdmobBannerId,
    adSize: AdmobBannerSize.BANNER,
  );
  return banner;
  }else{
    return Container();
  }
}
