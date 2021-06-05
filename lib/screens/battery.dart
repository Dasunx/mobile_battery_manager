import 'dart:async';

import 'package:battery/battery.dart';
import 'package:battery_manager/components/Bubbles.dart';
import 'package:battery_manager/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BatteryUI extends StatefulWidget {
  const BatteryUI({Key? key}) : super(key: key);

  @override
  _BatteryUIState createState() => _BatteryUIState();
}

class _BatteryUIState extends State<BatteryUI> {
  int _counter = 0;
  bool show = false;
  final Battery _battery = Battery();
  BatteryState? _batteryState;
  int? level;
  late StreamSubscription<BatteryState> _batteryStateSubscription;

  @override
  void initState() {
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
      // todo firebase registration login - Thanura
      // todo notification - notify level input - Kamal
      // todo add latest level to firebase history - Ashen
      if (state == BatteryState.charging) {
        print(state);
        setState(() {
          show = true;
        });
      } else {
        setState(() {
          show = false;
        });
      }
      getLevel();
      setState(() {
        _batteryState = state;
      });
    });
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  int batterylevel = 0;
  void getLevel() async {
    var l = await _battery.batteryLevel;
    setState(() {
      level = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battery Manager'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: primary_bg_color,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text("When do you need to get notify"),
            ),
            Expanded(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      border: Border.all(color: Colors.white),
                    ),
                  ),
                  Container(
                    width: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white),
                    ),
                    child: AnimatedContainer(
                      height: 300,
                      duration: Duration(seconds: 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: getGradient("status", 20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "97%",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Charging"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Text("History"),
            ),
          ],
        ),
      ),
    );
  }
}
