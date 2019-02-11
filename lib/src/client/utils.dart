import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:math';

class Utils {

  static bool trackIsAllAccess(String trackId) {
    // All access tracks begin with 'T'
    return trackId[0] == 'T';
  }

  /**
   * Get salt and sig based on method from
   * https://github.com/simon-weber/gmusicapi/blob/develop/gmusicapi/protocol/webclient.py
   */
  static Map<String,String> getSaltAndSign(String trackId) {
    String salt = randomString(13);
    String saltedTrack = trackId + salt;

    AsciiEncoder encoder = AsciiEncoder();

    String key = getKey();
    List<int> keyBin = encoder.convert(key);
    Hmac hmac = Hmac(sha1, keyBin);
    List<int> binToHash = encoder.convert(saltedTrack);
    List<int> hashedBin = hmac.convert(binToHash).bytes;
    String hashedStr = base64Encode(hashedBin);
    String urlSafeSig = hashedStr.replaceAll('+', '-')
        .replaceAll('/', '_')
        .replaceAll('=', '.');
    String sig = urlSafeSig.substring(0, urlSafeSig.length-1);

    return {
      'slt': salt,
      'sig': sig
    };
  }

  static String getKey() {
    // Calculate the key based on the method from:
    // https://github.com/simon-weber/gmusicapi/blob/develop/gmusicapi/protocol/mobileclient.py
    // McStreamCall
    String s1Base64 = 'VzeC4H4h+T2f0VI180nVX8x+Mb5HiTtGnKgH52Otj8ZCGDz9jRWyHb6QXK0JskSiOgzQfwTY5xgLLSdUSreaLVMsVVWfxfa8Rw==';
    String s2Base64 = 'ZAPnhUkYwQ6y5DdQxWThbvhJHN8msQ1rqJw0ggKdufQjelrKuiGGJI30aswkgCWTDyHkTGK9ynlqTkJ5L4CiGGUabGeo8M6JTQ==';
    List<int> s1Bytes = Utf8Encoder().convert(s1Base64);
    List<int> s2Bytes = Utf8Encoder().convert(s2Base64);

    List<int> s1Ands2 = [];
    for (int i = 0; i < s1Bytes.length; i++) {
      s1Ands2.add(s1Bytes[i] ^ s2Bytes[i]);
    }

    return AsciiDecoder().convert(s1Ands2);
  }

  static String randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(
        length,
            (index){
          return rand.nextInt(33)+89;
        }
    );

    return new String.fromCharCodes(codeUnits);
  }

  static String getDeviceIdForStream(String deviceId) {
    String deviceIdToSend = deviceId;
    if (isAndroidDeviceId(deviceId)) {
      if (deviceIdToSend.contains('0x')) {
        deviceIdToSend = deviceIdToSend.replaceAll('0x', '');
      }

      deviceIdToSend = int.parse(deviceIdToSend, radix:16).toString();
    }

    return deviceIdToSend;
  }

  static bool isAndroidDeviceId(String deviceId) {
    RegExp exp = new RegExp('^0x[a-z0-9]*\$');
    return deviceId.length == 18 && exp.hasMatch(deviceId);
  }
}