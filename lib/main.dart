import 'package:clock_app/constants/enums.dart';
import 'package:clock_app/home.dart';
import 'package:clock_app/models/menu_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('alarm_icon');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          onDidReceiveLocalNotification:
              (int id, String? title, String? body, String? payload) async {});
  final MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload) async {
    if (payload != null) {
      debugPrint('notification payload ' + payload);
    }
  });
  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('alarm_icon');
  // final IOSInitializationSettings initializationSettingsIOS =
  //     IOSInitializationSettings(
  //   requestSoundPermission: true,
  //   requestBadgePermission: true,
  //   requestAlertPermission: true,
  //   onDidReceiveLocalNotification:
  //       (int id, String? title, String? body, String? payload) async {},
  // );
  // final MacOSInitializationSettings initializationSettingsMacOS =
  //     MacOSInitializationSettings();
  // final InitializationSettings initializationSettings = InitializationSettings(
  //     android: initializationSettingsAndroid,
  //     iOS: initializationSettingsIOS,
  //     macOS: initializationSettingsMacOS);
  // await flutterLocalNotificationsPlugin.initialize(
  //   initializationSettings,
  //   onSelectNotification: (payload) async {
  //     if (payload != null) {
  //       debugPrint('notification payload ' + payload);
  //     }
  //   },
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<MenuInfo>(
          create: (context) =>
              MenuInfo(menuType: MenuType.CLOCK, title: '', imageSource: ''),
          child: MyHomePage()),
    );
  }
}
