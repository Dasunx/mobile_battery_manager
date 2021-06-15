import 'package:battery_manager/classes/new_user.dart';
import 'package:battery_manager/screens/authenticate/authenticate.dart';
import 'package:battery_manager/screens/battery.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<NewUser?>(context);
    print(user);

    // TODO: implement build
    if (user == null) {
      return Authenticate();
    } else {
      return BatteryUI();
    }
  }
}
