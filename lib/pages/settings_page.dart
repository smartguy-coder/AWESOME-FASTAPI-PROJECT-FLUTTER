import 'package:fastapiproject/pages/register_page.dart';
import 'package:fastapiproject/util/my_button.dart';
import 'package:flutter/material.dart';

import '../internal/access_internal_storage.dart';

class SettingsPage extends StatefulWidget {
  // final Future<void> Function() changeState;

  final changeStateMain;

  final checkIsRefreshTokenExpired;
  SettingsPage({
    super.key,
    // required this.changeState,
    // required this.checkIsRefreshTokenExpired,
    required this.checkIsRefreshTokenExpired,
    required this.changeStateMain,

  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  InternalDatabase db = InternalDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.95,
          child: ListView(
            children: [
              Row(
                children: [
                  Text('Theme:'),
                  Spacer(),
                  MyButton(
                    text: 'Change color',
                    onPressed: () {
                      InternalDatabase db = InternalDatabase();
                      var _currentThemeMode = db.getThemeMode();
                      var _newCurrentThemeMode =
                          _currentThemeMode == ThemeMode.light
                              ? ThemeMode.dark
                              : ThemeMode.light;

                      db.putData(themeMode: _newCurrentThemeMode);

                      widget.changeStateMain();
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Account:'),
                  Spacer(),
                  checkIsRefreshTokenExpired? MyButton(
                    text: 'Log In/Sing Up',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(
                            // checkIsRefreshTokenExpired: widget.checkIsRefreshTokenExpired,

                          ),
                        ),
                      );
                    },
                  ) : MyButton(
                    text: 'Log out',
                    onPressed: () {
                      setState(() {
                        db.putData(
                          accessToken: '',
                          refreshToken: '',
                          tokenType: '',
          
                        );
                        db.putRefreshTokenExpireDateTime(refreshTokenExpireDateTime: '');
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
