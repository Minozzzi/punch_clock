class PunchClock {
  static const TABLE_NAME = 'punchClock';
  static const FIELD_ID = 'id';
  static const FIELD_LATITUDE = 'latitude';
  static const FIELD_LONGITUDE = 'longitude';
  static const FIELD_DATE = 'date';

  int id;
  String latitude;
  String longitude;
  DateTime date;

  PunchClock(
      {required this.id,
      required this.latitude,
      required this.longitude,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      FIELD_ID: id,
      FIELD_LATITUDE: latitude,
      FIELD_LONGITUDE: longitude,
      FIELD_DATE: date.toIso8601String()
    };
  }

  static PunchClock fromMap(Map<String, dynamic> map) {
    return PunchClock(
        id: map[FIELD_ID],
        latitude: map[FIELD_LATITUDE],
        longitude: map[FIELD_LONGITUDE],
        date: DateTime.parse(map[FIELD_DATE]));
  }
}
