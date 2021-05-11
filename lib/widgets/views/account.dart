import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:good_deed/widgets/buttons/button_logout.dart';
import 'package:good_deed/widgets/copy_clipboard.dart';
import 'package:good_deed/widgets/views/user.dart';
import 'package:good_deed/models/user.dart' as GDUser;

//TODO put this all in settings?
class AccountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User fbUser = FirebaseAuth.instance.currentUser;
    return Column(
      children: [
        Text("Your ID is : "),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(FirebaseAuth.instance.currentUser.uid),
            CopyToClipboardWidget(onTapCopy: (){return FirebaseAuth.instance.currentUser.uid;}, message: "Copied your User ID to your clipboard"),
          ],
        ),
        Text("Share this with your friends so that they can easily find you, or keep it secret!", textAlign: TextAlign.center,),
        Divider(),
        LogoutButton(),
        UserView(user: new GDUser.User(uuid: fbUser.uid, name: fbUser.displayName, avatarURL: fbUser.photoURL),)
      ],
    );
  }
}
