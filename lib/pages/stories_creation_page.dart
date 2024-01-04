import 'package:fastapiproject/api/api_stories.dart';
import 'package:fastapiproject/pages/register_page.dart';
import 'package:fastapiproject/util/my_button.dart';
import 'package:fastapiproject/util/stories_forms/stories_tags_form.dart';
import 'package:fastapiproject/util/stories_forms/stories_text_form.dart';
import 'package:fastapiproject/util/stories_forms/stories_title_form.dart';
import 'package:flutter/material.dart';

import '../internal/access_internal_storage.dart';
import '../util/myDialogBox.dart';
import 'my_alert_page.dart';

InternalDatabase db = InternalDatabase();

class CreateStoriesPage extends StatefulWidget {
  final bool Function() isPostStoriesWorking;
  CreateStoriesPage({
    super.key,
    required this.isPostStoriesWorking,
  });

  @override
  State<CreateStoriesPage> createState() => _CreateStoriesPageState();
}

class _CreateStoriesPageState extends State<CreateStoriesPage> {
  final _title_controller = TextEditingController();
  final _text_controller = TextEditingController();
  int numberOfButtonPress = 0;
  final _tags_controller = TextEditingController();
  String text = '';
  var tags;

  Stream<bool> alwaysCheckPostStories() async* {
    final modalRoute = ModalRoute.of(context);
    while (db.getCurrentPageIndex() == 1 &&
        modalRoute != null &&
        modalRoute.isActive == true) {
      await Future.delayed(Duration(seconds: 2));

      if (db.getCurrentPageIndex() == 1 && modalRoute.isActive == true) {
        yield !widget.isPostStoriesWorking();
      } else {}
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return StreamBuilder(
        stream: alwaysCheckPostStories(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            return !snapshot.hasError && snapshot.data == true
                ? Scaffold(
                    appBar: AppBar(
                      title: Text('Add Stories'),
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
                            storiesTitleForm(controller: _title_controller),
                            storiesTextForm(controller: _text_controller),
                            storiesTagsForm(controller: _tags_controller),
                            MyButton(
                              text: 'Add',
                              onPressed: () async {
                                tags = (_tags_controller.text).split(' ');
                                for (var tag in tags) {
                                  if (tag == 'documentary' ||
                                      tag == 'fiction') {
                                  } else {
                                    tags = [];
                                  }
                                }
                                if (numberOfButtonPress == 0) {
                                  if (_title_controller.text.length == 0 ||
                                      _text_controller.text.length == 0) {
                                    text =
                                        "You fogot to write some data!\nSo error occurred:\n\n";
                                  }

                                  String answer = await postStories(
                                    text: _text_controller.text,
                                    title: _title_controller.text,
                                    tags: tags,
                                  ).then((value) {
                                    showDialogBox(
                                      context: context,
                                      text: [text, value].join(),
                                    );
                                    return value;
                                  });
                                  if (text.length > 0 || answer != '') {
                                    text = "";
                                    numberOfButtonPress = 0;
                                  } else {
                                    _title_controller.text = '';
                                    _text_controller.text = '';
                                    _tags_controller.text = '';
                                    numberOfButtonPress = 0;
                                  }
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Scaffold(
                    appBar: AppBar(
                      title: Text('Add Stories'),
                    ),
                    body: MyAlertPage(
                      text: 'Firstly you need to login into account',
                      needInButton: true,
                      needInFutureBuilder: false,
                      functionWhenLoad: () {},
                      buttonText: 'Log In/Sing Up',
                      onButtonPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                    ),
                  );
          } else {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary),
                  ],
                ),
              ),
            );
          }
        });
  }
}
