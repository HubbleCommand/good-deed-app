# Flutter Tips & Tricks : Known issues using android studio
- Project files not loading in project explorer -> [change from Android to Project view](https://github.com/flutter/flutter-intellij/issues/4806)
- Weird gradle version build crash, can be fixed by upgrading gradle with [this](https://www.google.com/search?q=flutter+upgrade+gradle+version), [this](https://medium.com/flutter-community/managing-packages-in-flutter-6018cecaf3a7), [this](https://www.reddit.com/r/Flutter/comments/dlluyj/update_gradle/), and [this](https://stackoverflow.com/questions/58505199/is-there-any-way-to-create-a-new-flutter-project-with-upgraded-gradle-version)
- Build issue No such file found error ...\external_file_lib_dex_archives\debug  can be fixed by [removing the .gradle folder from the android project](https://github.com/facebook/react-native/issues/28954)
- API errors with Google Sign In even after having filled out OAuth Consent Screen can be fixed by [adding all the required SHA keys to your firebase project](https://github.com/flutter/flutter/issues/56235#issuecomment-780786422)

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

## Web debugging
Many 3rd party services have security cross-origin requirements. Notably, google sign in only allows connections from specific URLs and ports.
Hence, instead of just hitting 'run', make sure to execute the following command when testing web versions:
`flutter run -d chrome --web-port 5000`

Also note that for using Firebase on the web, you need to add your [Firebase project config](https://firebase.google.com/docs/web/setup), and then call the Firebase configure method.
This is currently to be held in a file called includes.js, referenced by web/index.html.

## Web Hosting
- Build for the web : https://docs.flutter.dev/get-started/web
- Deploy to the web : https://docs.flutter.dev/deployment/web

Build a web version with `flutter build web`

Web hosting, once setup, is incredibly simple.

Make sure to change `<base href="/">` in `index.html` to the actual path.

The easiest way to serve is to just use Apache. You can put the web build wherever, 
```
<VirtualHost *:<port>>
    --- other stuff ---

    <Directory "/absolute/path/to/web/build">
		Require all granted
	</Directory>
	Alias /gooddeed "/absolute/path/to/web/build/"

    --- other stuff ---
</VirtualHost>
```
Take note that `Directory` doesn't include a trailing `/`, while `Alias` does.
Make sure that the www user has access to this path.
With this properly setup, there is absolutely no need for a proxy server (either nodejs, python, or dart dhttpd)