import 'package:fastapiproject/api/api_users.dart';
import 'package:fastapiproject/util/my_button.dart';
import 'package:flutter/material.dart';

import '../internal/access_internal_storage.dart';
import '../util/myDialogBox.dart';
import '../util/user_forms/email_form.dart';
import '../util/user_forms/password_form.dart';

InternalDatabase db = InternalDatabase();

class LoginPage extends StatefulWidget {
  LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email_controller = TextEditingController();
  final _password_controller = TextEditingController();
  int numberOfButtonPress = 0;
  String text = '';

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 5,
              ),
              EmailForm(controller: _email_controller),
              PasswordForm(controller: _password_controller),
              MyButton(
                  text: 'Login',
                  onPressed: () async {
                    if (numberOfButtonPress == 0) {
                      if (_email_controller.text.length == 0 ||
                          _password_controller.text.length == 0) {
                        text =
                            "You fogot to write some data!\nSo error occurred:\n\n";
                      }
                      numberOfButtonPress++;
                      String answer = await loginUser(
                              email: _email_controller.text,
                              password: _password_controller.text)
                          .then((value) {
                        showDialogBox(
                            context: context,
                            text: [text, value].join(),
                            buttonPressed: value == 'You are logged in!'
                                ? () async {
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                  }
                                : null);

                        return value;
                      });
                      if (text.length > 0 || answer != 'You are logged in!') {
                        text = "";
                        numberOfButtonPress = 0;
                      } else {
                        _email_controller.text = '';
                        _password_controller.text = '';
                        numberOfButtonPress = 0;
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
