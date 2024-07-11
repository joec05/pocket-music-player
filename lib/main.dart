import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:music_player_app/controllers/songs/fetch_songs_controller.dart';
import 'package:music_player_app/global_files.dart';
import 'package:audio_service/audio_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

Future<void> main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  GlobalObserver globalObserver = GlobalObserver();
  WidgetsBinding.instance.addObserver(globalObserver);
  await isarController.initialize();
  await initializeAudioService();
  await initializeDefaultStartingDisplayImage();
  final controller = FetchSongsController();
  await controller.fetchLocalSongs(LoadType.initial).then((_) {
    runApp(
      const MyApp()
    );
    FlutterNativeSplash.remove();
  });
}

final talker = Talker();

Future<void> initializeAudioService() async{
  if(appStateRepo.audioHandler == null){
    MyAudioHandler audioHandler = await AudioService.init(
      builder: () => MyAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.example.music_player_app',
        androidNotificationChannelName: 'Music playback',
      ),
    );
    audioHandler.initializeController();
    appStateRepo.audioHandler = audioHandler;
  }
}

Future<void> initializeDefaultStartingDisplayImage() async{
  ByteData byteData = await rootBundle.load('assets/images/music-icon.png');
  appStateRepo.audioImageData = byteData.buffer.asUint8List();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    appStateRepo.soundwaveAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      )
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
      theme: globalTheme.dark,
      initialBinding: StoreBinding()
    );
  }
}

class StoreBinding implements Bindings {
  @override
  void dependencies() {
    /// Get.lazyPut(() => appStateRepo.allAudiosList);
  }
}