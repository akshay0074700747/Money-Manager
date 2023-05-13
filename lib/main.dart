// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/authentication/widget_tree.dart';
import 'package:money_manager/hive/model_class.dart';
import 'package:money_manager/mainPages/expence_chart.dart';
import 'package:money_manager/notifications/notification_api.dart';

import 'mainPages/AccountPage.dart';
import 'mainPages/HomePage.dart';
import 'mainPages/transactionsPage.dart';
import 'mainPages/upcomingTransactionsPage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService().init();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(transactionsAdapter());
  Hive.registerAdapter(futuretransactionsAdapter());
  await Hive.openBox<transactions>('transactions');
  await Hive.openBox<futuretransactions>('futuretransactions');
  runApp( MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isnightmode,
      builder: (context, value, child) {
        return MaterialApp(
        
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
      primaryColor: Colors.lightGreen,
      brightness: Brightness.light
    ),
    darkTheme: ThemeData(
      primaryColor: Colors.lightGreen,
      brightness: Brightness.dark
    ),
    themeMode: isnightmode.value ?
    ThemeMode.light :
    ThemeMode.dark,
        home: widget_tree(),
      );
      },
    );
  }
}

class HomeNavigationPage extends StatefulWidget {
  HomeNavigationPage(this.currentIndex);
  int currentIndex;

  @override
  State<HomeNavigationPage> createState() => _HomeNavigationPageState();
}

class _HomeNavigationPageState extends State<HomeNavigationPage> {
  final screens = [
    HomePage(),
    TransactionPage(),
    PastTransactionsPage(),
    Mychart(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: widget.currentIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.greenAccent,
          currentIndex: widget.currentIndex,
          onTap: (index) => setState(() {
            widget.currentIndex = index;
          }),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.money), label: "Upcoming"),
            BottomNavigationBarItem(
                icon: Icon(Icons.credit_card), label: "Past"),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Expence Statistics"),
          ],
        ));
  }
}
