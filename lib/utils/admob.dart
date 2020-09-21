import 'package:firebase_admob/firebase_admob.dart';

class AdmobServive{
  String _appAdId;
  String _interstitialAdId;
  InterstitialAd _interstitialAd;
  bool _interstitialAdisOn = true;

  static const MobileAdTargetingInfo targetInfo = MobileAdTargetingInfo(
    testDevices: <String>[],
    keywords: <String>['book', 'books', 'game','games'],
    childDirected: false,
    nonPersonalizedAds: false
  );

  init(String appAdId, { String interstitialAdId }){
    _appAdId = appAdId;
    _interstitialAdId = interstitialAdId;
    FirebaseAdMob.instance.initialize(appId: _appAdId);
    // _bannerAd = createBannerAd()..load();
    _interstitialAd = createInterstitialAd()..load();
    // _nativeAd = createNativeAd()..load();
  }

  // BannerAd createBannerAd(){
  //   return new BannerAd(
  //     adUnitId: BannerAd.testAdUnitId, 
  //     size: AdSize.leaderboard,
  //     targetingInfo: targetInfo,
  //   );
  // }

  InterstitialAd createInterstitialAd(){
    return InterstitialAd(
      adUnitId: _interstitialAdId,
      targetingInfo: targetInfo
    );
  }

  // NativeAd createNativeAd() {
  //   return NativeAd(
  //     adUnitId: NativeAd.testAdUnitId,
  //     factoryId: null,
  //     targetingInfo: targetInfo,
  //     // listener: (MobileAdEvent event) {
  //     //   print("$NativeAd event $event");
  //     // },
  //   );
  // }

  // showNativeAd(){
  //   _nativeAd?.show();
  // }

  // showBannerAd(){
  //   _bannerAd?.show();
  // }

  showInterstitialAd(){
    _interstitialAdisOn = true;
    _interstitialAd?.show();
    _interstitialAd = createInterstitialAd()..load();
  }

  dispose(){
    // _bannerAd?.dispose();
    if(_interstitialAdisOn){
      _interstitialAd?.dispose();
      _interstitialAdisOn = false;
    }
  }

}