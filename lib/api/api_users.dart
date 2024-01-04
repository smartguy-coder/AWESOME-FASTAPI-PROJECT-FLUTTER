import 'dart:convert';

import 'package:fastapiproject/internal/access_internal_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../time/time_operations.dart';
import 'api_stories.dart';

InternalDatabase db = InternalDatabase();

Future<String> createUser({
  required String email,
  required String password,
  required String name,
}) async {
  var text;
  final headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };
  Map data = {"email": email, "password": password, "name": name};
  final url = Uri.parse('$httpAdress/api/users/create?');
  try {
    final response =
        await http.post(url, headers: headers, body: jsonEncode(data));
    final status = response.statusCode;
    final info = response.body;
    status == 201 ? null : throw ErrorDescription('$info');
  } catch (e) {
    text = '$e';
  }

  return text != null
      ? text
      : 'Now you need to activate your account \n(look in your mail box)';
}

Future<String> loginUser({
  required String email,
  required String password,
}) async {
  var text;
  try {
    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final data = 'username=$email&password=$password';
    final url = Uri.parse('$httpAdress/api/auth/login');

    final response = await http.post(url, headers: headers, body: data);
    final status = response.statusCode;

    Map<String, dynamic> responseMap = jsonDecode(response.body);
    final info = responseMap['detail'];
    if (status == 200) {
      db.putData(
        accessToken: responseMap['access_token'],
        refreshToken: responseMap['refresh_token'],
        tokenType: responseMap['token_type'],
      );
      db.putRefreshTokenExpireDateTime(
          refreshTokenExpireDateTime: calculateRefreshTokenExpireTime(
              number: responseMap['expires_in']));
    } else {
      throw ErrorDescription('$info');
    }
  } catch (e) {
    text = '$e';
  }
  return text != null ? text : 'You are logged in!';
}

Future<void> logoutUser() async {
  db.putData(
    accessToken: '',
    refreshToken: '',
    tokenType: '',
  );
  db.putRefreshTokenExpireDateTime(refreshTokenExpireDateTime: '');
}
