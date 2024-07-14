import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player_app/models/theme/theme_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage>{

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
          settingWidget(
            Image.asset('assets/images/music-icon.png', width: 30, height: 30),
            'Version',
            () {},
            subtitle: '1.0.0',
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