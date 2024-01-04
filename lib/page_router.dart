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
  final changeStateMain;

  PageRouter({Key? key, required this.changeStateMain}) : super(key: key);

  @override
  State<PageRouter> createState() => _PageRouterState();
}

class _PageRouterState extends State<PageRouter> {
  bool checkIsRefreshTokenExpired() {
    try {
      return isTimeExpired(db.getRefreshTokenExpireDateTime());
    } catch (error) {
      if ('$error' == 'No refresh token') {
        return true;
      } else
        throw ErrorDescription('$error');
    }
  }

  bool checkIsFetchStoriesWorking() {
    try {
      var stories;

      fetchStories().then((value) {
        stories = value;
      });
      if (stories.length > 0) {
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
      ),
      CreateStoriesPage(
        isPostStoriesWorking: checkIsRefreshTokenExpired,
      ),
      SettingsPage(
        checkIsRefreshTokenExpired: checkIsRefreshTokenExpired,
        changeStatePageRouter: changeStatePageRouter,
        changeStateMain: widget.changeStateMain,
      ),
    ];
    super.initState();
  }

  void _onBottomNavBarItemTapped(
    int index,
  ) {
    setState(
      () {
        db.putData(currentPageIndex: index);
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
