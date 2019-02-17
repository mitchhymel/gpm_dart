import 'dart:io';

import 'package:gpm_dart/gpm_dart.dart';
import 'package:http/http.dart';

void main() async {
  print('Starting...');

  var client = GooglePlayMusicClient.fromPath('./creds.json');

  bool loginFromCache = await client.tryLoginFromCachedCredentials();
  if (!loginFromCache) {
    Uri res = client.getAuthorizationUrl();
    print(res);

    stdout.writeln('Go to that url, click through and enter the code obtained:');
    String code = stdin.readLineSync();

    bool loggedIn = await client.handleAuthorizationCode(code, saveCredentialsToFile: true);
    if (!loggedIn) {
      print('Failed to login');
      return;
    }
  }
  else {
    print('Successful login from cached creds');
  }

//  var resp = await client.createPlaylist('test from dart',
//
//  );
//  print(resp.body);

//  var resp = await client.search("Makari",
//      maxResults: 10,
//  );
//  print(resp.body);

//  Response resp = await client.library(maxResults: 10);
//  print(resp.body);
//
//  IncrementalResponse<Track> lib = await client.libraryTyped(maxResults: 10);
//  lib.data.items.forEach((t) => print((t as Track).id));

  Response devices = await client.devices();
  print(devices.body);

  print('Finish');
}