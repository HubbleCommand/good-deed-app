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
                Text("Deeds are by their very nature supposed to be public. The nature of this platform is to share the good deeds around the world.\n"),
                Text("Please remember that simply looking and searching through deeds and users, does not require an account. However, an account is required to create Deeds.\n"),
                Text("Ads are served by google. You can change how ads are served to you in your google account settings. The only thing we take is the Avatar of your profile that is made publicly available by Firebase.\n"),
                Text("Logins are managed by Google's Firebase. You can feel save logging in, as not a single password is saved anywhere in our platform.\n"),
                Text("Your location can be used when you search for data, but your location remains private to you: us, nor other users, can see it.\n"),
                Text("You may, if you wish, put additional contact information for other users to see, but this is not necessary for using the platform.\n"),
              ],
            )
        )
    );
  }
}