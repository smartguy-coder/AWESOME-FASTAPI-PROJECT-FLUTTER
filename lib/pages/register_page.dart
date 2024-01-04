import 'package:fastapiproject/util/my_button.dart';
import 'package:flutter/material.dart';

import '../api/api_users.dart';
import '../util/myDialogBox.dart';
import '../util/user_forms/email_form.dart';
import '../util/user_forms/name_form.dart';
import '../util/user_forms/password_form.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  final changeUpdateImmediately;
  RegisterPage({
    super.key,
    this.changeUpdateImmediately,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _name_controller = TextEditingController();
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
        title: Text('Register'),
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
              NameForm(controller: _name_controller),
              EmailForm(controller: _email_controller),
              PasswordForm(controller: _password_controller),
              MyButton(
                  text: 'Create account',
                  onPressed: () async {
                    if (numberOfButtonPress == 0) {
                      if (_name_controller.text.length == 0 ||
                          _email_controller.text.length == 0 ||
                          _password_controller.text.length == 0) {
                        text =
                            "You foget to write some data!\nSo error occurred:\n\n";
                      }
                      numberOfButtonPress++;
                      String answer = await createUser(
                              name: _name_controller.text,
                              email: _email_controller.text,
                              password: _password_controller.text)
                          .then((value) {
                        showDialogBox(
                            context: context, text: [text, value].join());
                        return value;
                      });
                      if (text.length > 0 ||
                          answer !=
                              'Now you need to activate your account \n(look in your mail box)') {
                        text = "";
                        numberOfButtonPress = 0;
                      } else {
                        _name_controller.text = '';
                        _email_controller.text = '';
                        _password_controller.text = '';
                        numberOfButtonPress = 0;
                      }
                    }
                    ;
                  }),
              MyButton(
                text: 'Have an account? Lets login!',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(
                        changeUpdateImmediately: widget.changeUpdateImmediately,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
