import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_deed/routes/Routes.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PageBuilder {
  static Widget _wrapBodyInWillPopScope(BuildContext context, Widget body){
    //Wrap in WillPopScope for nav ?
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return new Future(() => true);
      },
      child: body,
    );
  }

  static AppBar _buildAppBar(BuildContext context, {String title, bool showActions = false}){
    return AppBar(
      title : title != null && title.isNotEmpty ? Text(title) : Text('Good Deed'),
      automaticallyImplyLeading: kIsWeb ? false : true,
      actions: !showActions ? [] : [
        IconButton(
          icon: Icon(Icons.info),
          onPressed: (){
            //Navigator.of(context).pushNamed(Routes.about);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('This is a snackbar')));
            Navigator.pushNamed(context, Routes.about);
          },
        ),
        IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: (){
            Navigator.pushNamed(context, Routes.account);
          },
        ),
      ],
    );
  }

  static _buildTallLayout(BuildContext context, Widget body, String basePath, {Widget floatingActionButton, String title}){
    List<String> pages = ['/home', '/deeds', '/users',];
    int selectedIndex = pages.indexWhere((element) => element == basePath);
    selectedIndex = selectedIndex < 0 ? 0 : selectedIndex;
    selectedIndex = selectedIndex >= pages.length ? pages.length - 1 : selectedIndex;

    return Scaffold(
      //Can't seem to use AppbarController, causes all sorts of issues...
      appBar:  _buildAppBar(context, showActions: true),
      body: _wrapBodyInWillPopScope(context, body),
      //TODO for some reason floatingActionButton won't show with  a BottomNavigationBar
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton : floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public_rounded),
            label: 'Deeds',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_3),
            label: 'Users',
          ),
        ],
        currentIndex : selectedIndex,
        onTap: (int index){
          Navigator.pushNamed(context, pages[index]);
        },
      ),
    );
  }

  static Scaffold _buildWideLayout(BuildContext context, Widget body, bool ultraWide, String basePath, {Widget floatingActionButton, String title}){
    //When the screen is wide enough, we put the navigation on the side : USE NavigationRail
    //https://itnext.io/navigation-rail-widget-flutter-1-17-229f7c5d3215
    //https://www.woolha.com/tutorials/flutter-using-navigationrail-widget-examples

    NavigationRailDestination buildNavigationRailButton(String text, IconData icon, IconData iconSelected){
      //return ultraWide ? buildNavigationRailButtonUltrawide(text, icon, iconSelected) : buildNavigationRailButtonWide(text, icon, iconSelected);
      return NavigationRailDestination(
        icon: Icon(icon),
        selectedIcon: Icon(iconSelected),
        label: Text(text),
      );
    }

    List<String> destinations = ['/home', '/deeds', '/users', '/account', '/about',];

    List<NavigationRailDestination> railDestinations = [
      buildNavigationRailButton('   Home', Icons.home, Icons.home),
      buildNavigationRailButton('  Deeds', Icons.public_rounded, Icons.public_rounded),
      buildNavigationRailButton('  Users', Icons.group, Icons.group),
      buildNavigationRailButton('Account', Icons.account_circle, Icons.account_circle),
      buildNavigationRailButton('  About', Icons.info, Icons.info),
    ];

    int selectedIndex = destinations.indexWhere((element) => element == basePath);

    return Scaffold(
      //appBar: AppBar(title : Text('Good Deed')),
      appBar: _buildAppBar(context),
      body: _wrapBodyInWillPopScope(context,
        Row(
          children: [
            NavigationRail(
              //Instead of using labelType & using different labels for NavigationRailDestination based on b:ultraWide, we can just use extended !
              extended: ultraWide,
              destinations : railDestinations,
              selectedIndex: selectedIndex,
              onDestinationSelected: (int index){
                Navigator.pushNamed(context, destinations[index]);
              },
            ),
            Expanded(
              child: body
            )
          ],
        )
      ),
      floatingActionButton : floatingActionButton,
    );
  }

  //static Scaffold build(BuildContext context, Widget body, String basePath, {FloatingActionButton floatingActionButton}) {
  //TODO add required
  static Scaffold build({BuildContext context, Widget body, String basePath, String title, Widget floatingActionButton}) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;

    if (shortestSide < 600)
      return _buildTallLayout(context, body, basePath);

    if (shortestSide > 900)
      return _buildWideLayout(context, body, true, basePath, floatingActionButton : floatingActionButton);

    return _buildWideLayout(context, body, false, basePath, floatingActionButton : floatingActionButton);
  }
}
