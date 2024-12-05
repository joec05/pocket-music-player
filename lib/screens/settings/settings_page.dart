import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pocket_music_player/global_files.dart';
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
      title: Text(title, style: const TextStyle(fontSize: 15)),
      subtitle: subtitle == null ? null : Text(subtitle, style: const TextStyle(fontSize: 13)),
      onTap: onTap
    );
  }

  Future<void> send() async {
    final Email email = Email(
      body: '',
      subject: 'Feedback',
      recipients: ['jcappcreations@gmail.com'],
      attachmentPaths: [],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      if(mounted) {
        handler.displaySnackbar(
          context, 
          SnackbarType.error, 
          error.toString()
        );
      }
    }
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
                Image.asset('assets/images/icon.png', width: 35, height: 35),
                'Version',
                () {},
                subtitle: packageInfo == null ? '1.0.0.0' : '${packageInfo.version}.${packageInfo.buildNumber}'
              );
            }
          ),
          ValueListenableBuilder(
            valueListenable: themeModel.mode,
            builder: (context, mode, child) => settingWidget(
              SizedBox(width: 35, child: Icon(mode == ThemeMode.dark ? FontAwesomeIcons.sun : FontAwesomeIcons.moon, size: 18.5)),
              'Theme',
              () {
                themeModel.toggleMode();
                Get.off(const SettingsPage());
              }
            )
          ),
          settingWidget(
            const SizedBox(width: 35, child: Icon(FontAwesomeIcons.userLock, size: 18.5)),
            'Privacy Policy',
            () async => await launchUrl(
              Uri.parse('https://joec05.github.io/privacy-policy.github.io/pocket-music-player/main.html'), 
              mode: LaunchMode.externalApplication
            )
          ),
          settingWidget(
            const SizedBox(width: 35, child: Icon(FontAwesomeIcons.envelope, size: 18.5)),
            'Send us a feedback',
            () async => await send()
          ),
        ]
      ),
    );
  }

}