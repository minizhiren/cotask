import 'package:flutter/material.dart';
import 'package:cotask/navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:cotask/providers/global_var_provider.dart';

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
            const NavigationBarPage(), // 0
          ][0]),
    );
  }
}
