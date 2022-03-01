import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_deed/utils/page_builder.dart';
import 'package:good_deed/widgets/privacy.dart';
import 'package:http/http.dart' as http;
import 'package:good_deed/widgets/drawer.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatelessWidget {
  static const String routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return PageBuilder.build(
        context: context,
        basePath: routeName,
        body : SingleChildScrollView(child: Column(
          children: [
            VersionWidget(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return PrivacyAlertDialog();
                      }
                  );
                },
                child: Text('Privacy Overview'),
              ),
            ),
            /*SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AboutAlertDialog();
                      }
                  );
                },
                child: Text('About Good Deed'),
              ),
            ),*/

            Text("""Good Deed is a positive app. It's goal is to allow people to see all the good things that people do across the world, through all of the hateful news.\n"""),
            Text("""To accomplish this, people signed up to the platform and anonymous users can create Posts about any good deed they did, or that has happened in their community.\n"""),
            Text("""Those who are signed up can also create Deeds, which are special posts between two or more users, that show directly the users involved, including who did and who recieved the good deed.\n"""),
            Text("""People signed up to the platform, and anonymous users, can then search through the good actions (Posts and Deeds) that have been done by other users.\n\n"""),
            Text("""Additionally, Good Deed embraces Open Data. All Deeds and Posts are available to the public for free, forever, through the app and an API. Please read the Privacy Overview or Privacy Policy to know how your data is protected."""),
          ],
        ),),
    );
  }
}

class VersionWidget extends StatefulWidget {
  @override
  _VersionWidgetState createState() => _VersionWidgetState();
}

class _VersionWidgetState extends State<VersionWidget> {
  Future<List<String>> _version;

  @override
  void initState() {
    super.initState();
    _version = getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FutureBuilder<List<String>>(
          future: _version,
          builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasData) {
              //return Text('App Version:  ${snapshot.data[0]}');
              return Column(
                children: [
                  Text('App Version:  ${snapshot.data[0]}'),
                  Text('App Build:  ${snapshot.data[1]}')
                ],
              );
            } else {
              return Text('...');
            }
          },
        ),
      ],
    );
  }
}

Future<List<String>> getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String appName = packageInfo.appName;
  String packageName = packageInfo.packageName;
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;

  return [version, buildNumber];
}