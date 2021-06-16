class HistoryData {
  final String userId;
  final int percentage;
  final DateTime date;

  HistoryData(
      {required this.userId, required this.percentage, required this.date});

  factory HistoryData.fromJson(Map<String, dynamic> json) {
    return HistoryData(
        userId: json['userId'],
        percentage: json['percentage'],
        date: json['date']);
  }
}
