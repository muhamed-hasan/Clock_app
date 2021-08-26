import 'package:clock_app/data.dart';
import 'package:clock_app/constants/enums.dart';
import 'package:clock_app/models/menu_info.dart';
import 'package:clock_app/views/TimerPage.dart';
import 'package:clock_app/views/alarm_page.dart';
import 'package:clock_app/views/clock_page.dart';
import 'package:clock_app/views/stopwatch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final formattedDate = DateFormat('EEE,d MMM').format(now);
    final timezone = now.timeZoneOffset.toString().split('.').first;
    var offsetSign = '';
    if (!timezone.startsWith('-')) {
      offsetSign = '+';
    }
    return Scaffold(
      backgroundColor: Color(0xFF2d2F41),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: menuItems.map((e) {
              return buildSideButton(e);
            }).toList(),
          ),
          VerticalDivider(color: Colors.white54, width: 1),
          Consumer<MenuInfo>(
            builder: (context, value, child) {
              if (value.menuType == MenuType.ALARM) {
                return AlarmPage();
              } else if (value.menuType == MenuType.STOPWATCH) {
                return StopWatchPage();
              } else if (value.menuType == MenuType.TIMER) {
                return TimerPage();
              }
              return ClockPage(
                  formattedDate: formattedDate,
                  offsetSign: offsetSign,
                  timezone: timezone);
            },
          ),
        ],
      ),
    );
  }

  Widget buildSideButton(MenuInfo currentMenuInfo) {
    return Consumer<MenuInfo>(
      builder: (context, value, child) => Container(
        margin: const EdgeInsets.symmetric(vertical: 16),

        //padding: const EdgeInsets.symmetric(vertical: 16),
        child: TextButton(
            style: TextButton.styleFrom(
                fixedSize: Size.square(97),
                backgroundColor: currentMenuInfo.menuType == value.menuType
                    ? Colors.deepPurpleAccent.withOpacity(.2)
                    : null),
            onPressed: () {
              final menuInfo = Provider.of<MenuInfo>(context, listen: false);
              menuInfo.updateMenu(currentMenuInfo);
            },
            child: Column(
              children: [
                Image.asset(
                  currentMenuInfo.imageSource,
                  scale: 1.5,
                ),
                SizedBox(height: 16),
                Text(
                  currentMenuInfo.title,
                  style: TextStyle(
                      color: Colors.white, fontSize: 14, fontFamily: 'avenir'),
                ),
              ],
            )),
      ),
    );
  }
}
