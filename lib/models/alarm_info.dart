class AlarmInfo {
  int? id;
  String title;
  DateTime alarmDateTime;
  int isPending;
  int gradientColorIndex;

  AlarmInfo(
      {this.id,
      required this.title,
      required this.alarmDateTime,
      this.isPending = 1,
      required this.gradientColorIndex});

  factory AlarmInfo.fromMap(Map<String, dynamic> json) => AlarmInfo(
        id: json["id"],
        title: json["title"],
        alarmDateTime: DateTime.parse(json["alarmDateTime"]),
        isPending: json["isPending"],
        gradientColorIndex: json["gradientColorIndex"],
      );

  get weekday => null;
  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "alarmDateTime": alarmDateTime.toIso8601String(),
        "isPending": isPending,
        "gradientColorIndex": gradientColorIndex,
      };
}
