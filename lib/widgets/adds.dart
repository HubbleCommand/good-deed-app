import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class BannerAdWidget extends StatelessWidget{
  final AdSize adSize;

  BannerAdWidget({AdSize adSize}) :
        adSize = adSize ?? AdSize.fullBanner;

  @override
  Widget build(BuildContext context){
    if(kIsWeb){
      //ui.platformViewRegistry.registerViewFactory();
      print("In the web!");
      return Container(
        alignment: Alignment.bottomCenter,
        child: Text('Web Ad'),
        width: adSize.width.toDouble(),
        height: adSize.height.toDouble(),
      );
    }

    //If we aren't in the web, we load & render the ad!
    BannerAd banner = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      //size: AdSize.fullBanner,
      size: (adSize != null) ? adSize : AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) => print('Ad loaded.'),
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.'),
        // Called when an ad is in the process of leaving the application.
      ),
    );
    banner.load();

    AdWidget adWidget = AdWidget(ad: banner);

    return Container(
      alignment: Alignment.bottomCenter,
      child: adWidget,
      width: banner.size.width.toDouble(),
      height: banner.size.height.toDouble(),
    );
  }
}