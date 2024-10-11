import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cotask/providers/global_var_provider.dart';

import 'package:cotask/home.dart';

class NavigationBarPage extends StatefulWidget {
  final bool showOrderConfirmationPage;

  const NavigationBarPage({
    super.key,
    this.showOrderConfirmationPage = false,
  });

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  bool _showSubGenreDetailPage = false;
  bool _showOrderConfirmationPage = false;

  List<Widget> _currentChildren = [];
  String _currentBarTitle = '';
  int _cid = 1;

  void navigateToDetailPage(List<Widget> children, String barTitle, int cid) {
    setState(() {
      _showSubGenreDetailPage = true;
      _currentChildren = children;
      _currentBarTitle = barTitle;
      _cid = cid;
    });
  }

  void navigateToMenuPage() {
    setState(() {
      _showSubGenreDetailPage = false;
    });
  }

  final List<String> _iconPaths = [
    "./assets/home_icon.png",
    "./assets/home_icon.png",
    "./assets/home_icon.png",
    "./assets/profile_icon.png",
  ];

  @override
  void initState() {
    super.initState();
    _showOrderConfirmationPage = widget.showOrderConfirmationPage;
  }

  void onTabTapped(int index) {
    setState(() {
      Provider.of<NavigationProvider>(context, listen: false)
          .setCurrentIndex(index);
      _showOrderConfirmationPage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    int currentIndex = navigationProvider.currentIndex;

    List<Widget> stackchildren = [
      //home
      const CoTaskHomePage(),
      const CoTaskHomePage(),
      const CoTaskHomePage(),
      const CoTaskHomePage(),
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: IndexedStack(
        index: currentIndex,
        children: stackchildren,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        selectedIndex: _showSubGenreDetailPage ? 1 : currentIndex,
        onDestinationSelected: onTabTapped,
        indicatorColor: Colors.transparent,
        destinations: List.generate(
          _iconPaths.length,
          (index) {
            return NavigationDestination(
              icon: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Image.asset(
                  _iconPaths[index],
                  color: _showOrderConfirmationPage
                      ? const Color(0xFFA9A9A9)
                      : currentIndex == index
                          ? const Color(0xFFFFC0CB)
                          : const Color(0xFFA9A9A9),
                ),
              ),
              label: '',
            );
          },
        ),
      ),
    );
  }
}
