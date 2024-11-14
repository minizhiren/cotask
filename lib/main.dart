import 'package:cotask/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:cotask/navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:cotask/providers/global_var_provider.dart';
import 'package:cotask/daily_task_page.dart';
import 'package:cotask/providers/task_provider.dart';
import 'package:cotask/providers/gorcery_provider.dart';
import 'package:cotask/providers/transfer_provider.dart';
import 'package:cotask/providers/user_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // list of state providers
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => DateProvider()),
        ChangeNotifierProvider(create: (_) => GroceryProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => TransferProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // add more providers here
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false, //hide debug banner
          title: 'Flutter Demo',
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              primaryColor: Color.fromARGB(255, 255, 255, 255)),
          // ignore: prefer_const_constructors
          home: [
            // change the index to text/debug single page
            // all pages should be WIRED by NavigationBarPage
            const NavigationBarPage(), //
            const DashBoardPage(), //1
            const DailyTaskPage(), //2
          ][0]),
    );
  }
}
