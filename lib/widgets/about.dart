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
            Text("""Good Deed is a positive app. It's goal is to allow people to see all the good things that people do across the world, through all of the hateful news."""),
          ],
        ),
      ),
    );
  }
}
