import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:good_deed/globals.dart';
import 'package:good_deed/routes/Routes.dart';
import 'package:good_deed/routes/deed.dart';
import 'package:good_deed/routes/deeds.dart';
import 'package:good_deed/routes/home.dart';
import 'package:good_deed/routes/unknown.dart';
import 'package:good_deed/routes/user.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
//import 'package:flutter_web_plugins/flutter_web_plugins.dart';
//import '' if (kIsWeb) 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async{
  if(kIsWeb){
    //setUrlStrategy(PathUrlStrategy());
  }

  WidgetsFlutterBinding.ensureInitialized();

  //Initialise ad stuff, but ONLY if on web, and ONLY if on mobile
  if(!kIsWeb){
    if(Platform.isIOS || Platform.isAndroid) {  //TODO Windows phone ?
      MobileAds.instance.initialize();
    }
  }

  //Initialise Firebase login stuff
  await Firebase.initializeApp();

  //Set default language
  //auto_localization: ^1.1.7
  //BaseLanguage().setBaseLanguage("en"); //Set default language
  runApp(GoodDeed());
}

class GoodDeed extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      /*localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        // TODO: uncomment the line below after codegen
        // AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('fr', ''), // French, no country code
        const Locale.fromSubtags(languageCode: 'de'), // Chinese *See Advanced Locales below*
      ],*/
      title: 'Good Deed',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Globals.styles.mainThemeColor,
        textTheme: TextTheme(
          /* TODO use
              https://www.didierboelens.com/2020/05/material-textstyle-texttheme/
              https://flutter.dev/docs/cookbook/design/themes
           */
        )
      ),
      //home: MyHomePage(title: 'Good Deed Home Page'),
      initialRoute: MyHomePage.routeName, //replaces home
      /*routes:  {
        Routes.deeds: (context) => DeedsPage(),
        Routes.home: (context) => MyHomePage(title: 'Good Deed Home Page'),
        Routes.privacy: (context) => PrivacyPage(),
        Routes.users: (context) => UsersPage(),
        Routes.account: (context) => AccountPage(),
      },*/
      routes: Routes.routes,

      //Navigator 2.0
      //Flutter Router checks the home / initial route, then the routes table, then tries onGenerateRoute
      //We ignore no return : if onGenerateRoute
      // ignore: missing_return
      onGenerateRoute: (settings) {
        print('Looking for route');
        print(settings);
        var uri = Uri.parse(settings.name);
        if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'deed') {
          print('Deed URL id passed : ' + uri.pathSegments[1]);
          var uuid = uri.pathSegments[1];
          //OH MY GOD settings WAS MISSING, that's all you need to pass for it to update the URL
          return MaterialPageRoute(settings: settings, builder: (context) => DeedPage(deedUUID: uuid));
        }

        /*if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'user') {
          print('User URL id passed : ' + uri.pathSegments[1]);
          return MaterialPageRoute(settings: settings, builder: (context) => UserPage(userUUID: uri.pathSegments[1]));
        }*/

        if(!Routes.routes.containsKey(settings.name)){
          return MaterialPageRoute(settings: settings, builder: (context) => UnknownPage());
        }
      },
    );
  }
}
