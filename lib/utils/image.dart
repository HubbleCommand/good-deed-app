import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_deed/globals.dart';
import 'package:good_deed/secrets/wasabi.dart';
import 'package:http/http.dart' as http;
import 'package:sigv4/sigv4.dart';

//TODO add to widgets? Not really a util...
class ImageUtil {
  static Widget buildIcon(String source, num height, num width){
    return Container(
        width: width,
        height: height,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage(source)
            )
        )
    );
  }

  static String getImageID(String url){
    List<String> res = url.split("/");
    return res[res.length - 1];
  }

  /*static Widget getImage(String id) {
    if(id.startsWith("http")){
      return Image.network(id);
    } else {
      //If no HTTP is specified / Protocol, probably is just image ID, so need to get from Wasabi with Auth

      var request = Globals.wasabiClient.request(Globals.wasabiEndpoint);
      print("HEADERS : " + json.encode(request.headers));
      print(request.headers);
      request.headers.addAll({"Host": "s3.eu-central-1.wasabisys.com"});
      http.get(request.url, headers: request.headers).then((value) {
          print("STATUS : " + value.statusCode.toString());
          //print("HEADERS");
          //print(value.headers);
          print("REQUEST" + value.request.toString());
          print("BODY : " + value.body);
      });
      //return Image.network(Globals.wasabiEndpoint + id, headers: request.headers); // Image.network(request.url.toString());
      //return Image.network(Globals.wasabiEndpoint + id + '?' + json.encode(request.headers));

      var client = Sigv4Client(
        keyId: WasabiSecrets.keyId,
        accessKey: WasabiSecrets.accessKey,
        region: 'eu-central-1',
        serviceName: 's3',
      );
      var request = client.request(Globals.wasabiEndpoint);
      var headers = request.headers;
      headers.addAll({"Host":"s3.eu-central-1.wasabisys.com"});
      print(headers);
      //return Image.network(Globals.backendURL + '/ftp/' + id);
      return Image.network(Globals.wasabiEndpoint + id);
    }
  }*/
}
