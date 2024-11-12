import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'providers/global_var_provider.dart';
import 'package:cotask/daily_task_page.dart';
import 'package:cotask/dashboard_page.dart';
import 'package:cotask/calendar_task_page.dart';
import 'package:cotask/create_task_page.dart';
import 'package:cotask/create_grocery_list_page.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  final List<String> _iconPaths = [
    'assets/Navigation_bar/home.svg',
    'assets/Navigation_bar/shopping_cart.svg',
    'assets/Navigation_bar/create.svg',
    'assets/Navigation_bar/calendar.svg', // Calendar icon at index 3
    'assets/Navigation_bar/dashboard.svg',
  ];

  void onTabTapped(int index) {
    setState(() {
      Provider.of<NavigationProvider>(context, listen: false)
          .setCurrentIndex(index);

      if (index == 3) {
        // Calendar tab
        // Hide the calendar dot notification when opening the calendar
        Provider.of<NotificationProvider>(context, listen: false).hideDot();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);

    int currentIndex = navigationProvider.currentIndex;

    List<Widget> stackChildren = [
      const DailyTaskPage(),
      GroceryListPage(),
      const CreateTaskPage(),
      CalendarTaskPage(),
      const DashBoardPage(),
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: IndexedStack(
        index: currentIndex,
        children: stackChildren,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        selectedIndex: currentIndex,
        onDestinationSelected: onTabTapped,
        indicatorColor: Colors.transparent,
        destinations: List.generate(
          _iconPaths.length,
          (index) {
            return NavigationDestination(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: SvgPicture.asset(
                      _iconPaths[index],
                      width: currentIndex == index ? 40 : 32,
                      color: currentIndex == index
                          ? Color(0xFFF66372)
                          : const Color(0xFFA9A9A9),
                    ),
                  ),
                  if (index == 3 && notificationProvider.showCalendarDot)
                    Positioned(
                      top: 9,
                      right: -3,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              label: '',
            );
          },
        ),
      ),
    );
  }
}
