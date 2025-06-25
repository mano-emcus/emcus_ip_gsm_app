import 'package:emcus_ipgsm_app/features/notes/models/note_entry.dart';

class SiteNotesResponse {
  factory SiteNotesResponse.fromJson(Map<String, dynamic> json) {
    return SiteNotesResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => NoteEntry.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  SiteNotesResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });
  final int statusCode;
  final String message;
  final List<NoteEntry> data;

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
} 