import 'package:flutter/material.dart';

class AboutAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "About Good Deed",
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text("""Good Deed is a positive app. It's goal is to allow people to see all the good things that people do across the world, through all of the hateful news.\n"""),
            Text("""To accomplish this, people signed up to the platform and anonymous users can create Posts about any good deed they did, or that has happened in their community.\n"""),
            Text("""Those who are signed up can also create Deeds, which are special posts between two or more users, that show directly the users involved, including who did and who recieved the good deed.\n"""),
            Text("""People signed up to the platform, and anonymous users, can then search through the good actions (Posts and Deeds) that have been done by other users.\n\n"""),
            Text("""Additionally, Good Deed embraces Open Data. All Deeds and Posts are available to the public for free, forever, through the app and an API. Please read the Privacy Overview or Privacy Policy to know how your data is protected."""),
          ],
        ),
      ),
    );
  }
}
