import 'dart:async';

import 'package:clock_app/constants/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StopWatchPage extends StatefulWidget {
  @override
  _StopWatchPageState createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  Timer? timer;
  // final List<ValueChanged<ElapsedTime>> timerListeners = <ValueChanged<ElapsedTime>>[];

  final Stopwatch stopwatch = new Stopwatch();
  final int timerMillisecondsRefreshRate = 30;
  String stopwatchTimer = '00:00';

  @override
  void initState() {
    if (stopwatch.isRunning) {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        // print(DateFormat('ss').format(DateTime.now()));

        setState(() {});
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    //  stopwatch.stop();
    if (timer != null) timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    stopwatchTimer =
        '${(stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, '0')} : ${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';

    return Expanded(
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stopwatch',
                style: TextStyle(
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w700,
                    color: CustomColors.primaryTextColor,
                    fontSize: 24),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 80),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                            width: 250,
                            height: 250,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.indigo,
                              value: ((stopwatch.elapsed.inSeconds % 60) / 60)
                                  .toDouble(),
                            )),
                        Text(
                          stopwatchTimer,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 64,
                              fontFamily: 'avenir'),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              stopwatch.start();
                              if (timer == null || timer!.isActive == false)
                                timer = Timer.periodic(Duration(seconds: 1),
                                    (timer) {
                                  // print(DateFormat('ss').format(DateTime.now()));

                                  setState(() {});
                                });
                            },
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 30,
                            )),
                        SizedBox(width: 50),
                        TextButton(
                            onPressed: () {
                              stopwatch.stop();
                              if (timer != null) timer!.cancel();
                            },
                            child: Icon(
                              Icons.stop,
                              color: Colors.white,
                              size: 30,
                            )),
                      ],
                    ),
                    SizedBox(height: 30),
                    TextButton(
                        onPressed: () {
                          stopwatch.reset();
                          setState(() {});
                        },
                        child: Text(
                          'Reset',
                          style: TextStyle(
                              fontFamily: 'avenir',
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 24),
                        )),
                  ]),
            ],
          )),
    );
  }
}
