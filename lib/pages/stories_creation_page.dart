// import 'package:fastapiproject/util/api_stories.dart';
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
  // const CreateStoriesPage({super.key});

  final checkIsPostStoriesWorking;
  // bool isRefreshTokenExpired;
  // final checkIsRefreshTokenExpired;
  CreateStoriesPage({
    super.key,
    required this.checkIsPostStoriesWorking,
    // required this.isRefreshTokenExpired,
    // required this.checkIsRefreshTokenExpired,
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
  @override
  Widget build(
    BuildContext context,
  ) {
    return FutureBuilder(
        future: widget.checkIsPostStoriesWorking(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
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
                            // storiesAuthorForm(controller: _author_controller),
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
                                      _text_controller.text.length ==
                                          0) // Tags are not needed!

                                  {
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

                                  // numberOfButtonPress++;
                                  // await showDialogBox(
                                  //   context: context,
                                  //   text: );await postStories(
                                  //     text: _text_controller.text,
                                  //     title: _title_controller.text,
                                  //     tags: tags,
                                  //   ).then((value){}).whenComplete(
                                  //     () async {
                                  //       // _title_controller.text = '';
                                  //       // _text_controller.text = '';
                                  //       // _tags_controller.text = '';
                                  //       // numberOfButtonPress = 0;
                                  //     },
                                  //   ),
                                  //
                                }

                                // _title_controller.text = '';
                                // _text_controller.text = '';
                                // _tags_controller.text = '';
                                // _author_controller.text = '';
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
                            builder: (context) => RegisterPage(
                                // checkIsRefreshTokenExpired:widget.checkIsRefreshTokenExpired,
                                ),
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
