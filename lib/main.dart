import 'package:flutter/material.dart';
import 'package:music_player_app/main_page.dart';
import 'package:music_player_app/observer/global_observer.dart';
import 'package:music_player_app/redux/redux_library.dart';
import 'package:music_player_app/sqflite/local_db_configuration.dart';

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
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
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
