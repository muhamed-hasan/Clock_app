import 'dart:math';

import 'package:clock_app/alarm_helper.dart';
import 'package:clock_app/constants/theme_data.dart';
import 'package:clock_app/data.dart';
import 'package:clock_app/main.dart';
import 'package:clock_app/models/alarm_info.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  DateTime? alarmTime;
  String alarmTimeString = "HH:MM";
  AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>>? _alarms;
  List<AlarmInfo>? _currentAlarms;


  @override
  void initState() {

    alarmTime = DateTime.now();
    _alarmHelper.initialzeDatabase().then((_) {
      print('database intialized');
    });
    tz.initializeTimeZones();
    super.initState();
    loadAlarms();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alarm',
              style: TextStyle(
                  fontFamily: 'avenir',
                  fontWeight: FontWeight.w700,
                  color: CustomColors.primaryTextColor,
                  fontSize: 24),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                  future: _alarms,
                  builder: (context, AsyncSnapshot<List<AlarmInfo>?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.map<Widget>((alarm) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 32),
                            padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: GradientTemplate
                                    .gradientTemplate[alarm.gradientColorIndex]
                                    .colors,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(24),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: GradientTemplate
                                      .gradientTemplate[
                                          alarm.gradientColorIndex]
                                      .colors
                                      .last
                                      .withOpacity(.4),
                                  blurRadius: 8,
                                  spreadRadius: 4,
                                  offset: Offset(4, 4),
                                )
                              ],
                            ),
                            child: alarmContent(alarm),
                          );
                        }).followedBy([addAlarmButton()]).toList(),
                      );
                    }
                    return Center(child: Text('Loading'));
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Column alarmContent(AlarmInfo alarm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.label,
                  color: Colors.yellow,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'OFFICE',
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'avenir'),
                ),
              ],
            ),
            Switch(
              value: true,
              activeColor: Colors.deepPurple,
              onChanged: (value) {
                //
              },
            )
          ],
        ),
        Text(
          DateFormat('E').format(alarm.alarmDateTime),
          style: TextStyle(
              color: Colors.deepPurple,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'avenir'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('HH:mm').format(alarm.alarmDateTime),
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'avenir'),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                size: 35,
                color: Colors.red,
              ),
              onPressed: () {
                _alarmHelper.delete(alarm.id ?? -1).then((value) async {
                  await flutterLocalNotificationsPlugin.cancel(alarm.id!);
                  loadAlarms();
                });
              },
            )
          ],
        ),
      ],
    );
  }

  DottedBorder addAlarmButton() {
    return DottedBorder(
      dashPattern: [5, 4],
      strokeWidth: 3,
      color: CustomColors.clockOutline,
      borderType: BorderType.RRect,
      radius: Radius.circular(24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: CustomColors.clockBG,
            borderRadius: BorderRadius.all(Radius.circular(24))),
        child: TextButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(vertical: 30))),
          onPressed: () {
            bottomSheet();
          },
          child: Column(
            children: [
              Image.asset(
                'assets/icons/add_alarm.png',
                scale: 1.5,
              ),
              SizedBox(height: 8),
              Text(
                'Add Alarm',
                style: TextStyle(
                    fontFamily: 'avenir',
                    //  fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onScheduleAlarm(DateTime scheduleAlarmTime) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'alarm_icon',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
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
    var lastid = await _alarmHelper.getLastAlarmid();

    await flutterLocalNotificationsPlugin.zonedSchedule(
        lastid!,
        'OFFICE',
        'good morning , time for office',
        tz.TZDateTime.from(scheduleAlarmTime, tz.UTC),
        //tz.TZDateTime.now(tz.local).add(Duration(seconds: 2)),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void onSaveAlarm(BuildContext context, DateTime schTime) {
    DateTime scheduleAlarm;

    if (schTime.isAfter(DateTime.now())) {
      scheduleAlarm = schTime;
    } else {
      scheduleAlarm = schTime.add(Duration(days: 1));
    }

    final alarmInfo = AlarmInfo(
        title: 'title',
        alarmDateTime: scheduleAlarm,
        gradientColorIndex:
            Random().nextInt(GradientTemplate.gradientTemplate.length));
    _alarmHelper.insertAlarm(alarmInfo);
    loadAlarms();
    onScheduleAlarm(scheduleAlarm);
    Navigator.pop(context);
    loadAlarms();
  }

  void bottomSheet() {
    alarmTimeString = DateFormat('HH:mm').format(DateTime.now());
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  FlatButton(
                    onPressed: () async {
                      var selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        final now = DateTime.now();
                        var selectedDateTime = DateTime(now.year, now.month,
                            now.day, selectedTime.hour, selectedTime.minute);
                        alarmTime = selectedDateTime;
                        setModalState(() {
                          alarmTimeString =
                              DateFormat('HH:mm').format(selectedDateTime);
                        });
                      }
                    },
                    child: Text(
                      alarmTimeString,
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  ListTile(
                    title: Text('Repeat'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  ListTile(
                    title: Text('Sound'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  ListTile(
                    title: Text('Title'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  FloatingActionButton.extended(
                    onPressed: () {
                      onSaveAlarm(context, alarmTime!);
                    },
                    icon: Icon(Icons.alarm),
                    label: Text('Save'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
