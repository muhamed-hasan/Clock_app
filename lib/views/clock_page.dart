import 'dart:async';

import 'package:clock_app/constants/theme_data.dart';
import 'package:clock_app/views/clock_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClockPage extends StatelessWidget {
  const ClockPage({
    Key? key,
    required this.formattedDate,
    required this.offsetSign,
    required this.timezone,
  }) : super(key: key);

  final String formattedDate;
  final String offsetSign;
  final String timezone;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FittedBox(
        alignment: Alignment.topLeft,
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Clock',
                style: TextStyle(
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w700,
                    color: CustomColors.primaryTextColor,
                    fontSize: 24),
              ),
              SizedBox(height: 32),
              DigitalTimeView(),
              Text(
                formattedDate,
                style: TextStyle(
                    color: Colors.white, fontSize: 24, fontFamily: 'avenir'),
              ),
              SizedBox(height: 44),
              ClockView(),
              SizedBox(height: 60),
              Text(
                'Timezone',
                style: TextStyle(
                    color: Colors.white, fontSize: 24, fontFamily: 'avenir'),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.language, color: Colors.white),
                  SizedBox(width: 16),
                  Text(
                    'UTC' + offsetSign + timezone,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'avenir'),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 7)
            ],
          ),
        ),
      ),
    );
  }
}

class DigitalTimeView extends StatefulWidget {
  @override
  _DigitalTimeViewState createState() => _DigitalTimeViewState();
}

class _DigitalTimeViewState extends State<DigitalTimeView> {
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // print(DateFormat('ss').format(DateTime.now()));
      if (DateFormat('ss').format(DateTime.now()) == '00') {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('HH:mm').format(DateTime.now());
    return Text(
      formattedTime,
      style: TextStyle(color: Colors.white, fontSize: 64, fontFamily: 'avenir'),
    );
  }
}
