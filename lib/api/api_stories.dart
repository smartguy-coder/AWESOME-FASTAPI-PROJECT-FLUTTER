import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../internal/access_internal_storage.dart';

// String httpAdress = 'https://awesome-project-edu.online';
String httpAdress = 'https://0602-5-133-47-43.ngrok-free.app';
InternalDatabase db = InternalDatabase();

Future<List> fetchStories() async {
  // Using Function: try to get list of stories however check for ErrorDescription and show them using Navigator.push if needed
  try {
    int limit = 50;
    int skip = 0;
    // Construct the query parameters
    // https://awesome-project-edu.online/api/stories?limit=10&skip=0
    var uri = Uri.parse('$httpAdress/api/stories?limit=$limit&skip=$skip#skip');

    final response = await http.get(
      uri,
    );
    final status = response.statusCode;
    final info = response.body;
    if (status == 200 || status == 201) {
      var list = jsonDecode(info);
      if (list.length > 0) {
        return list;
      }
      throw ErrorDescription(
          'There are no stories yet.\nMaybe you will create first one?');
    } else {
      throw ErrorDescription('$info');
    }
  } catch (e) {
    throw ErrorDescription('$e');
  }
}

Future<String> postStories({
  // Using Function: try to get string however check for ErrorDescription and show them using Navigator.push if needed

  required String text,
  required String title,
  List tags = const [],
}) async {
  var textResponse;
  var responseMap = await sendStories(text: text, title: title, tags: tags);
  var status = responseMap['status'];
  var info = responseMap['info'];
  try {
    status == 201
        ? null
        : await () async {
            // if first time with old tokens it did not work we refresh tokens
            await refreshTokens();
            var responseMap =
                await sendStories(text: text, title: title, tags: tags);
            status = responseMap['status'];
            info = responseMap['info'];
            status == 201
                ? null
                : throw ErrorDescription(
                    '$info'); // if second time with new tokens it did not work we throw ErrorDescription
          };
  } catch (e) {
    textResponse = '$e';
  }
  return textResponse != null ? textResponse : 'The story have been sent!';
}

Future<Map> sendStories({
  // part of postStories function
  required String text,
  required String title,
  List tags = const [],
}) async {
  String tokenType = await db.getTokenType();
  String accessToken = await db.getAccessToken();
  var url = Uri.parse('$httpAdress/api/stories/add');
  Map data = {
    "text": text,
    "title": title,
    "tags": tags,
  };
  var response = await http.post(
    url,
    headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': '$tokenType $accessToken',
    },
    body: jsonEncode(data),
  );
  return {'status': response.statusCode, 'info': response.body};
}

Future<void> refreshTokens() async {
  // part of postStories function
  String refreshToken = db.getRefreshToken();
  final headers = {
    'accept': 'application/json',
    'refresh-token': refreshToken,
    'content-type': 'application/x-www-form-urlencoded',
  };

  final data = '';

  final url = Uri.parse('$httpAdress/api/auth/refresh');

  final response = await http.post(url, headers: headers, body: data);
  Map<String, dynamic> responseMap = jsonDecode(response.body);
  db.putData(
    accessToken: responseMap['accessToken'],
    refreshToken: responseMap['refreshToken'],
    tokenType: responseMap['tokenType'],
  );
  db.putRefreshTokenExpireDateTime(
      refreshTokenExpireDateTime: responseMap['expires_at']);
}
