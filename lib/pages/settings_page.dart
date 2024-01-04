import 'package:fastapiproject/api/api_users.dart';
import 'package:fastapiproject/pages/my_alert_page.dart';
import 'package:fastapiproject/pages/register_page.dart';
import 'package:fastapiproject/util/myDialogBox.dart';
import 'package:fastapiproject/util/my_button.dart';
import 'package:flutter/material.dart';

import '../internal/access_internal_storage.dart';

class SettingsPage extends StatefulWidget {
  final changeStateMain;

  final bool Function() checkIsRefreshTokenExpired;
  final changeStatePageRouter;
  SettingsPage({
    super.key,
    required this.checkIsRefreshTokenExpired,
    required this.changeStatePageRouter,
    required this.changeStateMain,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  InternalDatabase db = InternalDatabase();
  bool isUpdateFirstTime = true;
  bool updateImmediately = false;
  Future<void> changeUpdateImmediately() async {
    setState(() {
      updateImmediately = true;
    });
  }

  Stream<bool> alwaysCheckToken() async* {
    final modalRoute = ModalRoute.of(context);
    while (db.getCurrentPageIndex() == 2 &&
        modalRoute != null &&
        modalRoute.isActive == true) {
      if (!isUpdateFirstTime && !updateImmediately) {
        await Future.delayed(Duration(seconds: 3));
      }
      await Future.delayed(Duration(milliseconds: 1));
      isUpdateFirstTime = false;
      updateImmediately = false;
      if (db.getCurrentPageIndex() == 2 && modalRoute.isActive == true) {
        yield widget.checkIsRefreshTokenExpired();
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: alwaysCheckToken(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data != null && !snapshot.hasError) {
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
                          snapshot.data
                              ? MyButton(
                                  text: 'Log In/Sing Up',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterPage(
                                            changeUpdateImmediately:
                                                changeUpdateImmediately),
                                      ),
                                    );
                                  },
                                )
                              : MyButton(
                                  text: 'Log out',
                                  onPressed: () async {
                                    showDialogBox(
                                        context: context,
                                        text: 'You are logged out!',
                                        buttonPressed: () => setState(() {
                                              logoutUser();

                                              changeUpdateImmediately()
                                                  .then((value) {
                                                Navigator.of(context).popUntil(
                                                    (route) => route.isFirst);
                                              });
                                            }));
                                  },
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Stories'),
              ),
              body: MyAlertPage(
                functionWhenLoad: () {},
                needInFutureBuilder: true,
                text: snapshot.hasError ? '${snapshot.error}' : 'Entire error!',
                onButtonPress: () async {
                  db.putData(currentPageIndex: 1);
                  widget.changeStatePageRouter();
                },
              ),
            );
          }
        });
  }
}
