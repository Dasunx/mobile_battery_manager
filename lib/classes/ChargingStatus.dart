import 'dart:async';
import 'package:flutter/material.dart';
import 'package:battery/battery.dart';

class ChargingStatus extends StatefulWidget {
  const ChargingStatus({Key? key}) : super(key: key);

  @override
  _ChargingStatusState createState() => _ChargingStatusState();
}

class _ChargingStatusState extends State<ChargingStatus> {
  final battery = Battery();
  BatteryState batteryState = BatteryState.full;

  late Timer timer;
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();

    listenBatteryState();
  }

  void listenBatteryState() =>
      subscription = battery.onBatteryStateChanged.listen(
            (batteryState) => setState(() => this.batteryState = batteryState),
      );

  @override
  void dispose() {
    timer.cancel();
    subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Battery Charging Status'),
      centerTitle: true,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildBatteryState(batteryState),
          const SizedBox(height: 32),
        ],
      ),
    ),
  );

  Widget buildBatteryState(BatteryState batteryState) {
    final style = TextStyle(fontSize: 32, color: Colors.white);
    final double size = 300;

    switch (batteryState) {
      case BatteryState.full:
        final color = Colors.green;

        return Column(
          children: [
            Icon(Icons.battery_full, size: size, color: color),
            Text('Full!', style: style.copyWith(color: color)),
          ],
        );
      case BatteryState.charging:
        final color = Colors.green;

        return Column(
          children: [
            Icon(Icons.battery_charging_full, size: size, color: color),
            Text('Charging...', style: style.copyWith(color: color)),
          ],
        );
      case BatteryState.discharging:
      default:
        final color = Colors.red;
        return Column(
          children: [
            Icon(Icons.battery_alert, size: size, color: color),
            Text('Discharging...', style: style.copyWith(color: color)),
          ],
        );
    }
  }
}
