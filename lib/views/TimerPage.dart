import 'dart:async';

import 'package:clock_app/constants/theme_data.dart';
import 'package:clock_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with TickerProviderStateMixin {
  late AnimationController controller;
  double progress = 1.0;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 60));
    controller.addListener(() {
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        progress = 1.0;
      }
    });
  }

  String get countText {
    Duration count = controller.duration! * controller.value;
    // print(controller.duration);
    // print(controller.value);
    //return count.inSeconds.toString();

    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    //controller.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Timer',
                style: TextStyle(
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w700,
                    color: CustomColors.primaryTextColor,
                    fontSize: 24),
              ),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 80),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                              width: 250,
                              height: 250,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white24,
                                value: progress,
                                strokeWidth: 5,
                              )),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: 300,
                                    child: CupertinoTimerPicker(
                                      initialTimerDuration:
                                          controller.duration!,
                                      onTimerDurationChanged: (value) {
                                        setState(() {
                                          controller.stop();
                                          controller.duration = value;
                                        });
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            child: AnimatedBuilder(
                              animation: controller,
                              builder: (context, child) => Text(
                                //TODO
                                countText,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 64,
                                    fontFamily: 'avenir'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                if (controller.isAnimating) {
                                  controller.stop();
                                } else {
                                  controller.reverse(
                                      from: controller.value == 0
                                          ? 1
                                          : controller.value);
                                }
                                setState(() {});
                                onScheduleAlarm(controller.duration!);
                              },
                              child: Icon(
                                !controller.isAnimating
                                    ? Icons.play_arrow
                                    : Icons.pause,
                                color: Colors.white,
                                size: 30,
                              )),
                          SizedBox(width: 50),
                          TextButton(
                              onPressed: () {
                                controller.reset();
                                setState(() {});
                              },
                              child: Icon(
                                Icons.stop,
                                color: Colors.white,
                                size: 30,
                              )),
                        ],
                      ),
                    ]),
              ),
            ],
          )),
    );
  }

  void onScheduleAlarm(Duration duration) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 1', 'CHANNEL_NAME 1', 'CHANNEL_DESCRIPTION 1',
      icon: 'alarm_icon',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      importance: Importance.max,
      playSound: true,
      largeIcon: DrawableResourceAndroidBitmap('alarm_icon'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Timer',
        'Timer Done , Timer Done',
        tz.TZDateTime.now(tz.UTC).add(duration),
        //   tz.TZDateTime.now(tz.local).add(Duration(seconds: 1)),
        //tz.TZDateTime.now(tz.local).add(Duration(seconds: 2)),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
