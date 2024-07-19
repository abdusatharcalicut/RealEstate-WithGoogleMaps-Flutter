import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:publrealty/extensions/global_extensions.dart';
import 'package:publrealty/localizations/app_localizations.dart';
import 'package:publrealty/providers/authentication_provider.dart';
import 'package:publrealty/providers/liked_properties_provider.dart';
import 'package:publrealty/screens/authentication/authentication_root_screen.dart';
import 'package:publrealty/screens/home_screen.dart';
import 'package:publrealty/screens/menu_screen.dart';
import 'package:publrealty/screens/profile_screen.dart';
import 'package:publrealty/screens/search_screen.dart';
import 'package:publrealty/themes/app_themes.dart';

class RootScreen extends StatefulWidget {
  static final rootScreenKey = GlobalKey<_RootScreenState>();

  RootScreen() : super(key: RootScreen.rootScreenKey);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  static const List<Widget> _tabPages = <Widget>[
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
    MenuScreen(),
  ];

  final Map<int, Widget> _pages = {
    0: const HomeScreen(),
    1: Container(),
    2: Container(),
    3: Container(),
  };

  @override
  void initState() {
    super.initState();
    prepare();
  }

  void prepare() async {
    try {
      final authProvider = AuthenticationProvider.of(context);
      await authProvider.prepare();
      if (mounted && authProvider.isLoggedIn) {
        await LikedPropertiesProvider.of(context).fetchLikedProperties();
      }
    } catch (e) {
      handleException(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = AppThemes.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages.values.toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: theme.customLabelColor.withOpacity(0.4),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: localization.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: localization.search,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: localization.profile,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu),
            label: localization.menu,
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          changeTab(index);
        },
      ),
    );
  }

  void changeTab(int index) {
    if (_pages[index] is Container) {
      _pages[index] = _tabPages.elementAt(index);
    }

    if (_pages[index] is ProfileScreen) {
      if (AuthenticationProvider.of(context).isLoggedIn == false) {
        Navigator.of(context).push(
          CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => AuthenticationRootScreen(),
          ),
        );
        return;
      }
    }

    setState(() {
      _currentIndex = index;
    });
  }
}
