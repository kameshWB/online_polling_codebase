import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onlinre_polling/screens/00-home/home.dart';
import 'package:onlinre_polling/screens/01-dashboard/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(OnlinePolling());
}

class OnlinePolling extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Online Polling',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      initialRoute: HomePage.id,
      // initialRoute: DashboardPage.id,
      routes: {
        HomePage.id: (context) => HomePage(),
        DashboardPage.id: (context) => DashboardPage(),
      },
    );
  }
}
