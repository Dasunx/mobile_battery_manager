import 'dart:async';

import 'package:battery/battery.dart';
import 'package:battery_manager/classes/BatteryNotificationLvl.dart';
import 'package:battery_manager/constants/constants.dart';
import 'package:battery_manager/services/auth.dart';
import 'package:battery_manager/services/notificationService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BatteryUI extends StatefulWidget {
  const BatteryUI({Key? key}) : super(key: key);

  @override
  _BatteryUIState createState() => _BatteryUIState();
}

final AuthService _auth = AuthService();

class _BatteryUIState extends State<BatteryUI> {
  int _counter = 0;
  bool batteryCharging = true;
  final Battery _battery = Battery();
  BatteryState? _batteryState;
  int level = 0;
  late StreamSubscription<BatteryState> _batteryStateSubscription;

  // notifications
  bool notificationAvailability = false;
  late int notificationLvl;
  late String notificationId;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController lvlController = TextEditingController();

  Future<void> readNotification() async {
    try {
      lvlController.text = '';

      // todo: place this in the real battery stream subscription (notificationLvl===streamBatLvl)
      NotificationService().showNotification(
          'Battery has reached your custom notification level.');

      var response = await firestore
          .collection('notifications')
          .where('userId', isEqualTo: 'companyDummy4')
          .get();

      if (response.docs.isNotEmpty) {
        notificationAvailability = true;

        var notification =
            BatteryNotificationLvl.fromJson(response.docs.first.data());

        setState(() {
          notificationLvl = notification.lvl;
        });

        print(notification.lvl);
        notificationId = response.docs.first.id;
      }
    } catch (err) {
      print(err);
      throw err;
    }
  }

  @override
  initState() {
    readNotification();

    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
      if (state == BatteryState.charging) {
        if (batteryCharging == false) {
          // methanin batteryCharging kiyana eka false kiyanne me aluth state ekata kalin charge ekata gahala nathuwa thibila thiyanne
          // E kiyanne dan me charge ekata gahuwa gaman listner eken update eka awe. Me welawe thiyana chargelevel eke level kiyana variable eken ganna puluwan
          // eka aran date ekayi username ekayi ekka history ekata danna. 
          print("update previously charged level here ${level}");
        }
        setState(() {
          batteryCharging = true;
        });
      } else {
        setState(() {
          batteryCharging = false;
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
    CollectionReference notifications = firestore.collection('notifications');

    Future<void> addNotification() {
      return notifications
          .add({
            'lvl': int.parse(lvlController.text),
            'userId': 'companyDummy4',
          })
          .then((value) => readNotification())
          .catchError((error) => print("Failed to add notifier: $error"));
    }

    Future<void> updateNotification() {
      print('update btn pressed');
      return notifications
          .doc(notificationId)
          .update({'lvl': int.parse(lvlController.text)})
          .then((value) => readNotification())
          .catchError((error) => print("Failed to add notifier: $error"));
    }


    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Battery Manager'),
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width,
          color: primary_bg_color,
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            notificationAvailability
                                ? "Update your notification level"
                                : "Please set the notification level",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              notificationAvailability
                                  ? RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(text: 'Current: '),
                                          TextSpan(
                                              text: notificationLvl.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.purpleAccent)),
                                        ],
                                      ),
                                    )
                                  : SizedBox()
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
                                  child: TextField(
                                    controller: lvlController,
                                    keyboardType: TextInputType.number,
                                  )),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
                                  child: TextButton(
                                    onPressed: lvlController.text.isEmpty
                                        ? null
                                        : notificationAvailability
                                            ? () => updateNotification()
                                            : () => addNotification(),
                                    child: Text(notificationAvailability
                                        ? 'Update'
                                        : 'Add'),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )),
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
                          gradient: getGradient(level),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${level}%",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(batteryCharging ? "Charging" : "Discharging"),
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
      ),
    );
  }
}
