import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pocket_music_player/models/theme/theme_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

  @override
  void initState() {
    super.initState();
  }

  Widget settingWidget(Widget leading, String title, Function() onTap, {subtitle}) {
    return ListTile(
      leading: leading,
      title: Text(title, style: const TextStyle(fontSize: 15.5)),
      subtitle: subtitle == null ? null : Text(subtitle, style: const TextStyle(fontSize: 12.5)),
      onTap: onTap
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings')
      ),
      body: ListView(
        children: [
          FutureBuilder(
            future: PackageInfo.fromPlatform(), 
            builder: (_, snapshot) {
              final PackageInfo? packageInfo = snapshot.data;
              return settingWidget(
                Image.asset('assets/images/icon.png', width: 30, height: 30),
                'Version',
                () {},
                subtitle: packageInfo == null ? '1.0.0.0' : '${packageInfo.version}.${packageInfo.buildNumber}'
              );
            }
          ),
          ValueListenableBuilder(
            valueListenable: themeModel.mode,
            builder: (context, mode, child) => settingWidget(
              SizedBox(width: 30, child: Icon(mode == ThemeMode.dark ? FontAwesomeIcons.sun : FontAwesomeIcons.moon, size: 18.5)),
              'Theme',
              () {
                themeModel.toggleMode();
                Get.off(const SettingsPage());
              }
            )
          ),
          settingWidget(
            const SizedBox(width: 30, child: Icon(FontAwesomeIcons.userLock, size: 16.5)),
            'Privacy Policy',
            () async => await launchUrl(
              Uri.parse('https://joec05.github.io/privacy-policy.github.io/pocket-music-player/main.html'), 
              mode: LaunchMode.externalApplication
            )
          ),
          settingWidget(
            const SizedBox(width: 30, child: Icon(FontAwesomeIcons.github, size: 21.5)),
            'Github',
            () async => await launchUrl(
              Uri.parse('https://github.com/joec05/pocket-music-player'), 
              mode: LaunchMode.externalApplication
            )
          )
        ]
      ),
    );
  }

}