import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabase().initDatabase();
  GlobalObserver globalObserver = GlobalObserver();
  WidgetsBinding.instance.addObserver(globalObserver);
  runApp(
    const MyApp()
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
      theme: globalTheme.dark
    );
  }
}
