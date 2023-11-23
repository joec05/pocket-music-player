// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:music_player_app/MainPage.dart';
import 'package:music_player_app/observer/GlobalObserver.dart';
import 'package:music_player_app/redux/reduxLibrary.dart';
import 'package:music_player_app/sqflite/localDatabaseConfiguration.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabase().initDatabase();
  GlobalObserver globalObserver = GlobalObserver();
  WidgetsBinding.instance.addObserver(globalObserver);
  runApp(
    StoreProvider(
      store: store, 
      child: const MyApp()
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) =>
              const MainPageWidget()
            );
          default:
            assert(false, 'Page ${settings.name} not found');
            return null;
        }
      },
      theme: ThemeData.dark()
    );
  }
}
