import 'package:docuzer/core/routes.dart';
import 'package:docuzer/ui/custom_icons.dart';
import 'package:docuzer/ui/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _TabItem {
  final Widget icon;
  final String initialRoute;
  final Widget? activeIcon;
  final GlobalKey<NavigatorState> navigatorKey;

  const _TabItem({
    required this.icon,
    required this.initialRoute,
    required this.navigatorKey,
    this.activeIcon,
  });

  Widget getPage() => Navigator(
    key: navigatorKey,
    initialRoute: initialRoute,
    onGenerateRoute: Routes.routesGenerator,
  );

  BottomNavigationBarItem getNavigationItem() => BottomNavigationBarItem(
    icon: icon,
    activeIcon: activeIcon,
  );
}

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {

  late final List<_TabItem> _tabItems = [
    _TabItem(
      icon: const Icon(Icons.dashboard),
      initialRoute: 'templates',
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
    _TabItem(
      icon: const Icon(CustomIcons.home),
      activeIcon: const Icon(CustomIcons.homeActive),
      initialRoute: 'home',
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
    _TabItem(
      icon: const Icon(CustomIcons.profile),
      initialRoute: 'users',
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
  ];

  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await _tabItems[_currentIndex].navigatorKey.currentState!.maybePop(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: IndexedStack(
          index: _currentIndex,
          children: _tabItems.map((tab) => tab.getPage()).toList(),
        ),
        bottomNavigationBar: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            boxShadow: Themes.upShadow,
          ),
          child: CupertinoTabBar(
            border: null,
            backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            iconSize: Theme.of(context).bottomNavigationBarTheme.selectedIconTheme!.size!,
            activeColor: Theme.of(context).bottomNavigationBarTheme.selectedIconTheme!.color,
            inactiveColor: Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme!.color!,
            currentIndex: _currentIndex,
            items: _tabItems.map((tab) => tab.getNavigationItem()).toList(),
            onTap: (index) {
              if (index == _currentIndex) {
                _tabItems[index].navigatorKey.currentState!.popUntil((route) => route.isFirst);
              } else {
                setState(() => _currentIndex = index);
              }
            },
          ),
        ),
      ),
    );
  }
}