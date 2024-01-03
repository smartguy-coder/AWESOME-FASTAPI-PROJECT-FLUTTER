// Stories page
import 'package:fastapiproject/pages/home_page.dart';
import 'package:fastapiproject/pages/settings_page.dart';
import 'package:fastapiproject/pages/stories_creation_page.dart';
import 'package:fastapiproject/time/time_operations.dart';
import 'package:flutter/material.dart';

import 'api/api_stories.dart';
import 'internal/access_internal_storage.dart';

int _currentPageIndex = 0;
InternalDatabase db = InternalDatabase();

class PageRouter extends StatefulWidget {
  // final Future<VoidCallback>  changeState;
  final changeStateMain;

  PageRouter({Key? key, required this.changeStateMain}) : super(key: key);

  @override
  State<PageRouter> createState() => _PageRouterState();
}

class _PageRouterState extends State<PageRouter> {
    Future<bool> checkIsPostStoriesWorking() async {
    
    try {
      return isTimeExpired(db.getRefreshTokenExpireDateTime());
    } catch (error) {
      if ('$error' == 'No refresh token') {
        return false;
      } else 
      throw ErrorDescription('$error');
      
    }
  }




    Future<bool> checkIsFetchStoriesWorking() async {
    try {
      List stories = await fetchStories();
      if (stories.isNotEmpty) {
        return true;
      }
      throw ErrorDescription('Failed to load stories');
    } catch (e) {
      throw ErrorDescription('$e');
    }
  }
 
  late final List<Widget> pages;
  void changeStatePageRouter() {
    setState(() {
      _currentPageIndex = db.getCurrentPageIndex();
    });
  }
  
  @override
  void initState() {
    pages = [
      HomePage(
        changeStatePageRouter: changeStatePageRouter,
      ), // 0
      CreateStoriesPage(
        checkIsPostStoriesWorking :checkIsPostStoriesWorking,
        // isRefreshTokenExpired: isRefreshTokenExpired,

        // checkIsRefreshTokenExpired: checkIsRefreshTokenExpired,
      ), // 1
      SettingsPage(

        changeStateMain: widget.changeStateMain,
        // checkIsRefreshTokenExpired: checkIsRefreshTokenExpired,
      ), // 2
    ];
    super.initState();
  }
  void _onBottomNavBarItemTapped(
    int index,
  ) {
    setState(
      () {
        checkIsFetchStoriesWorking;
        _currentPageIndex = index;
      },
    );
  }
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
            ),
            label: 'Add Stories',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: 'Settings',
          ),
        ],
        currentIndex: _currentPageIndex,
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        unselectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onBottomNavBarItemTapped,
      ),
    );
  }
}
// Navigator.push(
// context,
// MaterialPageRoute(builder: (context) => ScreenB()),
// );
