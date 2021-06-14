import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_deed/widgets/privacy.dart';
import 'package:good_deed/widgets/about.dart';
import 'package:http/http.dart' as http;
import 'package:good_deed/widgets/drawer.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatelessWidget {
  static const String routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("About Good Deed"),
        ),
        drawer: GDDrawer(),
        body: Column(
          children: [
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
            SizedBox(
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
            ),
            VersionWidget()
          ],
        )
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