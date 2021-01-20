import 'package:flutter/material.dart';
import 'package:good_deed/routes/Routes.dart';

import 'package:good_deed/widgets/home.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';

var url = 'https://localhost:3000';

void main() {
  runApp(GoodDeed());
}

class GoodDeed extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(title: 'Good Deed Home Page'),
      /*routes:  {
        Routes.deeds: (context) => DeedsPage(),
        Routes.home: (context) => MyHomePage(title: 'Good Deed Home Page'),
        Routes.privacy: (context) => PrivacyPage(),
        Routes.users: (context) => UsersPage(),
        Routes.account: (context) => AccountPage(),
      },*/
      routes: Routes.routes,
    );
  }
}
