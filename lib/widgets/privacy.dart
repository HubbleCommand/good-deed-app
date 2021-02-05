import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrivacyAlertDialog extends StatelessWidget {
  Widget _buildListItem(String title, String subtitle){
    return ListTile(
      leading: Icon(CupertinoIcons.dot_square),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
            'Privacy Overview'
        ),
        content: SingleChildScrollView(
            child: Column(
              children: [
                Text("Please note that this is not our full privacy policy. It does however cover the guiding principles of how Good Deed ensures the protection and privacy of your data. Our Privacy Policy can be seen on our website. \n"),
                Text("Good Deed takes your privacy and data very seriously. There are, however, some limits to what can be kept private on this platform.\n"),
                Text("Deeds are by their very nature supposed to be public. The nature of this platform is to share the good deeds around the world. The same thing applies to Posts.\n"),
                Text("Please remember that simply looking and searching through deeds, posts, and users, does not require an account. However, an account is required to create Posts and Deeds.\n"),
                Text("""Data is kept under four levels of protection."""),
                _buildListItem("public", """stored in the database, and visible to anyone."""),
                _buildListItem("private", """stored in the database, but is invisible and only used during queries"""),
                Text("""\nThere are two other levels of data protection that are especially pertinant if you don't feel comfortable having your data stored in our databases"""),
                _buildListItem("local", """data is stored only locally on your device"""),
                _buildListItem("none", """data is never stored anywhere, and doesn't need to be entered for you to use our platform, such as your contact and home information"""),
                Text("More specifically, here is how you can work with your data's privacy.\n"),
                _buildListItem("Your login info", """ : the account that you login with is hidden to everyone (private)"""),
                _buildListItem("Your name", """ : your name doesn't have to be your real name. Anything innoffensive that can be used to identify you. It is however only public (public)."""),
                _buildListItem("Your contact info", """ : it is up to you to put contact info, but it isn't necessary (public, private, none)"""),
                _buildListItem("Your home location", """ : (public, private, local, none)"""),
              ],
            )
        )
    );
  }
}