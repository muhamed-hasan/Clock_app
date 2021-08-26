import 'package:clock_app/constants/theme_data.dart';
import 'package:clock_app/constants/enums.dart';
import 'package:clock_app/models/alarm_info.dart';
import 'package:clock_app/models/menu_info.dart';
import 'package:clock_app/views/clock_page.dart';

List<MenuInfo> menuItems = [
  MenuInfo(
      menuType: MenuType.CLOCK,
      title: 'Clock',
      imageSource: 'assets/icons/clock_icon.png'),
  MenuInfo(
      menuType: MenuType.ALARM,
      title: 'Alarm',
      imageSource: 'assets/icons/alarm_icon.png'),
  MenuInfo(
      menuType: MenuType.TIMER,
      title: 'Timer',
      imageSource: 'assets/icons/timer_icon.png'),
  MenuInfo(
      menuType: MenuType.STOPWATCH,
      title: 'Stopwatch',
      imageSource: 'assets/icons/stopwatch_icon.png'),
];
// List<AlarmInfo> alarms = [
//   AlarmInfo(
//       alarmDateTime: DateTime.now(),
//       gradientColorIndex: 1,
//       id: 1,
//       isPending: 1,
//       title: 'Office'),
//   AlarmInfo(
//       alarmDateTime: DateTime.now(),
//       gradientColorIndex: 2,
//       id: 2,
//       isPending: 0,
//       title: 'Home'),
// ];
