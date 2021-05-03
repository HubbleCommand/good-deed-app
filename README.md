# Flutter Tips & Tricks : Known issues using android studio
- project files not loading in project explorer -> [change from Android to Project view](https://github.com/flutter/flutter-intellij/issues/4806)
- Weird gradle version build crash, can be fixed by upgrading gradle with [this](https://www.google.com/search?q=flutter+upgrade+gradle+version), [this](https://medium.com/flutter-community/managing-packages-in-flutter-6018cecaf3a7), [this](https://www.reddit.com/r/Flutter/comments/dlluyj/update_gradle/), and [this](https://stackoverflow.com/questions/58505199/is-there-any-way-to-create-a-new-flutter-project-with-upgraded-gradle-version)
# Good Deed Cross-Platform Mobile App

Flutter application to share good deeds. 

User can say another did a good deed for them: short description, image/video, etc. Every day show global good deed counter.

[Thing with similar name but more like GoFundMe](https://www.goodeed.com/)

Data types:
Deeder : person who did the deed (name)
Deed   : the good deed (doer, reciever, ranking (good, awesome, amazing, legendary), date, duration, location)

Need:
- QR code scanning / Bluetooth for easily posting a deed (recognizing users)

Useful flutter resources:
- [Toast / user "console" messages](https://flutter.dev/docs/release/breaking-changes/scaffold-messenger)
- [Nav drawer](https://medium.com/flutter-community/flutter-vi-navigation-drawer-flutter-1-0-3a05e09b0db9)
- [REST requests to a NodeJS + Express backend](https://carmine.dev/posts/multipartpost/)
- [Official Nav Drawer doc](https://flutter.dev/docs/cookbook/design/drawer)
- [Ad banner](https://codelabs.developers.google.com/codelabs/admob-ads-in-flutter#0)
- [Bluetooth](https://blog.kuzzle.io/communicate-through-ble-using-flutter)
- [QR code](https://pub.dev/packages/qrscan)
- [List of all icons](https://api.flutter.dev/flutter/material/Icons-class.html)
- [Flutter for web devs](https://flutter.dev/docs/get-started/flutter-for/web-devs)
- [Taking pics](https://flutter.dev/docs/cookbook/plugins/picture-using-camera)

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
