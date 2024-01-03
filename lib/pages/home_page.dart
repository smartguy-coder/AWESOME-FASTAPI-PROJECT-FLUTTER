import 'package:fastapiproject/api/api_stories.dart';
import 'package:flutter/material.dart';

import '../util/story_box.dart';
import 'my_alert_page.dart';

// List<dynamic> listStories = [];
// String textError = '';

class HomePage extends StatefulWidget {
  final changeStatePageRouter;
  const HomePage({Key? key, required this.changeStatePageRouter})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  

  var error;
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
        future: fetchStories(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null && !snapshot.hasError) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Stories'),
                ),
                body: Center(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Story(
                        author: snapshot.data[index]['author'],
                        text: snapshot.data[index]['text'],
                        title: snapshot.data[index]['title'],
                        tagsList: snapshot.data[index]['tags'],
                      );
                    },
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
                // needInButton: true,
                // buttonText: 'Create new story',
                onButtonPress: () async {
                  db.putData(currentPageIndex: 1);
                    widget.changeStatePageRouter();
                },
              ),
            );
          }
        });

    // return widget.isFetchStoriesWorking.then((bool) {
    //   if (bool) {
    //     return Scaffold(
    //       appBar: AppBar(
    //         title: Text('Stories'),
    //       ),
    //       body: Center(
    //         child: ListView.builder(
    //           itemCount: listStories.length,
    //           itemBuilder: (context, index) {
    //             return Story(
    //               author: listStories[index]['author'],
    //               text: listStories[index]['text'],
    //               title: listStories[index]['title'],
    //               tagsList: listStories[index]['tags'],
    //             );
    //           },
    //         ),
    //       ),
    //     );
    //   }
    // }).catchError((error) {});
    // ? Scaffold(
    //     appBar: AppBar(
    //       title: Text('Stories'),
    //     ),
    //     body: Center(
    //       child: ListView.builder(
    //         itemCount: listStories.length,
    //         itemBuilder: (context, index) {
    //           return Story(
    //             author: listStories[index]['author'],
    //             text: listStories[index]['text'],
    //             title: listStories[index]['title'],
    //             tagsList: listStories[index]['tags'],
    //           );
    //         },
    //       ),
    //     ),
    //   )
    // : Scaffold(
    //     appBar: AppBar(
    //       title: Text('Stories'),
    //     ),
    //     body: MyAlertPage(
    //       text: 'Failed to load stories!',
    //       onButtonPress: () {},
    //     ),
    //   );
  }
}
