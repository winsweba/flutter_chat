import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.  

  
  //com.example.flutter_chat
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        dialogBackgroundColor: Colors.black,
        primarySwatch: Colors.grey,
       cardColor: Colors.white70,
       accentColor: Colors.black,
      ),
      home: Home(),
    );
  }
}
