import 'package:f1_calendar/pages/home.dart';
import 'package:f1_calendar/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class PageHandler extends StatelessWidget {
  const PageHandler({Key? key}) : super(key: key);

  List<Widget> buildScreens() {
    return [
      Home(),
      Settings()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: "Home",
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: "Settings",
      ),
    ];
  }
    
  @override
  Widget build(BuildContext context) {
    PersistentTabController pageController;
    pageController = PersistentTabController(initialIndex: 0);
    
    return PersistentTabView(
        context,
        controller: pageController,
        screens: buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
}
