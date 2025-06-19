class LogEntry {
  LogEntry({
    required this.id,
    required this.u16EventId,
    required this.logNum,
    required this.u8DeviceText,
    required this.u8ZoneNumber,
    required this.u8NodeAddress,
    required this.u8DeviceAddress,
    required this.u8DeviceType,
    required this.u8DeviceSubType,
    required this.u8Date,
    required this.u8Month,
    required this.u8Year,
    required this.u8Hours,
    required this.u8Minutes,
    required this.u8Seconds,
    required this.u8Logbitoffset,
    required this.u16Crc,
    required this.source,
    required this.createdAt,
  });

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      id: json['id'] as int,
      u16EventId: json['u16_event_id'] as int,
      logNum: json['log_num'] as int,
      u8DeviceText: json['u8_device_text'] as String,
      u8ZoneNumber: json['u8_zone_number'] as int,
      u8NodeAddress: json['u8_node_address'] as int,
      u8DeviceAddress: json['u8_device_address'] as int,
      u8DeviceType: json['u8_device_type'] as int,
      u8DeviceSubType: json['u8_device_sub_type'] as int,
      u8Date: json['u8_date'] as int,
      u8Month: json['u8_month'] as int,
      u8Year: json['u8_year'] as int,
      u8Hours: json['u8_hours'] as int,
      u8Minutes: json['u8_minutes'] as int,
      u8Seconds: json['u8_seconds'] as int,
      u8Logbitoffset: json['u8_logbitoffset'] as int,
      u16Crc: json['u16_crc'] as int,
      source: json['source'] as String,
      createdAt: json['createdAt'] as String,
    );
  }
  final int id;
  final int u16EventId;
  final int logNum;
  final String u8DeviceText;
  final int u8ZoneNumber;
  final int u8NodeAddress;
  final int u8DeviceAddress;
  final int u8DeviceType;
  final int u8DeviceSubType;
  final int u8Date;
  final int u8Month;
  final int u8Year;
  final int u8Hours;
  final int u8Minutes;
  final int u8Seconds;
  final int u8Logbitoffset;
  final int u16Crc;
  final String source;
  final String createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'u16_event_id': u16EventId,
      'log_num': logNum,
      'u8_device_text': u8DeviceText,
      'u8_zone_number': u8ZoneNumber,
      'u8_node_address': u8NodeAddress,
      'u8_device_address': u8DeviceAddress,
      'u8_device_type': u8DeviceType,
      'u8_device_sub_type': u8DeviceSubType,
      'u8_date': u8Date,
      'u8_month': u8Month,
      'u8_year': u8Year,
      'u8_hours': u8Hours,
      'u8_minutes': u8Minutes,
      'u8_seconds': u8Seconds,
      'u8_logbitoffset': u8Logbitoffset,
      'u16_crc': u16Crc,
      'source': source,
      'createdAt': createdAt,
    };
  }

  /// Get formatted date string
  String get formattedDate {
    return '${u8Date.toString().padLeft(2, '0')}/${u8Month.toString().padLeft(2, '0')}/$u8Year';
  }

  /// Get formatted time string
  String get formattedTime {
    return '${u8Hours.toString().padLeft(2, '0')}:${u8Minutes.toString().padLeft(2, '0')}:${u8Seconds.toString().padLeft(2, '0')}';
  }

  /// Get formatted date and time string in format: 2024-02-08 01:42:16 AM
  String get formattedDateTime {
    // Convert to 12-hour format with AM/PM
    final int hour12 =
        u8Hours == 0 ? 12 : (u8Hours > 12 ? u8Hours - 12 : u8Hours);
    final String amPm = u8Hours < 12 ? 'AM' : 'PM';

    return '$u8Year-${u8Month.toString().padLeft(2, '0')}-${u8Date.toString().padLeft(2, '0')} ${hour12.toString().padLeft(2, '0')}:${u8Minutes.toString().padLeft(2, '0')}:${u8Seconds.toString().padLeft(2, '0')} $amPm';
  }
}
