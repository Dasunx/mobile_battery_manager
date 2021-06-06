class BatteryNotificationLvl {
  final int lvl;
  final String userId;

  BatteryNotificationLvl({required this.lvl, required this.userId});

  factory BatteryNotificationLvl.fromJson(Map<String, dynamic> json) {
    return BatteryNotificationLvl(lvl: json['lvl'], userId: json['userId']);
  }
}
