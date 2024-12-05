import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:pocket_music_player/controllers/songs/fetch_songs_controller.dart';
import 'package:pocket_music_player/global_files.dart';
import 'package:audio_service/audio_service.dart';
import 'package:pocket_music_player/models/theme/theme_model.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:pocket_music_player/controllers/shared_preferences/shared_preferences_controller.dart';
import 'package:pocket_music_player/controllers/permission/permission_controller.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:device_preview/device_preview.dart';

final controller = FetchSongsController();
final talker = Talker();
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final mediaStorePlugin = MediaStore();

Future<void> main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  GlobalObserver globalObserver = GlobalObserver();
  WidgetsBinding.instance.addObserver(globalObserver);
  await isarController.initialize();
  await sharedPreferencesController.initialize();
  themeModel.mode.value = await sharedPreferencesController.getThemeModeData();
  await initializeAudioService();
  await initializeDefaultStartingDisplayImage();
  await MediaStore.ensureInitialized();
  MediaStore.appFolder = "Pocket Music Player";
  await controller.fetchLocalSongs(LoadType.initial).then((_) {
    runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const MyApp()
      )
    );
    FlutterNativeSplash.remove();
  });
}

Future<void> initializeAudioService() async{
  if(appStateRepo.audioHandler == null){
    MyAudioHandler audioHandler = await AudioService.init(
      builder: () => MyAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.pocket_music_player',
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
    verifyUserPermission();
    appStateRepo.audioHandler!.audioStateController.playerState.listen((playerState) {
      if(playerState == AudioPlayerState.playing) {
        appStateRepo.soundwaveAnimationController?.repeat();
      } else {
        appStateRepo.soundwaveAnimationController?.stop();
      }
    });
  }

  void verifyUserPermission() async {
    if(!permission.audioIsGranted) {
      final _ = await permission.requestAudio();
      await controller.fetchLocalSongs(LoadType.initial);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeModel.mode,
      builder: (context, mode, child) => GetMaterialApp(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,

        scaffoldMessengerKey: rootScaffoldMessengerKey,
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
        theme: globalTheme.light,
        darkTheme: globalTheme.dark,
        themeMode: mode,
        initialBinding: StoreBinding()
      )
    );
  }
}

class StoreBinding implements Bindings {
  @override
  void dependencies() {
    /// Get.lazyPut(() => appStateRepo.allAudiosList);
  }
}