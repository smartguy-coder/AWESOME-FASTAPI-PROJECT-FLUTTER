import 'package:fastapiproject/api/api_stories.dart';
import 'package:flutter/material.dart';

import '../util/story_box.dart';
import 'my_alert_page.dart';

class HomePage extends StatefulWidget {
  final changeStatePageRouter;
  const HomePage({Key? key, required this.changeStatePageRouter})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var error;
  bool isUpdateFirstTime = true;
  bool updateImmediately = false;

  Future<void> changeUpdateImmediately() async {
    setState(() {
      updateImmediately = true;
    });
  }

  Stream<List> alwaysFetchStories() async* {
    final modalRoute = ModalRoute.of(context);
    while (db.getCurrentPageIndex() == 0 &&
        modalRoute != null &&
        modalRoute.isActive == true) {
      if (!updateImmediately && !isUpdateFirstTime) {
        await Future.delayed(Duration(seconds: 30));
      }

      updateImmediately = false;
      isUpdateFirstTime = false;
      if (db.getCurrentPageIndex() == 0 && modalRoute.isActive == true) {
        yield await fetchStories();
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: changeUpdateImmediately,
        child: StreamBuilder(
            stream: alwaysFetchStories(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data != null && !snapshot.hasError) {
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
                    text: snapshot.hasError
                        ? '${snapshot.error}'
                        : 'Entire error!',
                    onButtonPress: () async {
                      db.putData(currentPageIndex: 1);
                      widget.changeStatePageRouter();
                    },
                  ),
                );
              }
            }));
  }
}
