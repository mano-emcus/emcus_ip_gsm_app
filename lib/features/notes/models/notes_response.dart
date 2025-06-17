import 'package:emcus_ipgsm_app/features/notes/models/note_entry.dart';

class NotesResponse {
  factory NotesResponse.fromJson(Map<String, dynamic> json) {
    return NotesResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data:
          json['data'] != null
              ? (json['data'] as List)
                  .map(
                    (item) => NoteEntry.fromJson(item as Map<String, dynamic>),
                  )
                  .toList()
              : [],
    );
  }

  NotesResponse({
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

class NotesErrorResponse {
  NotesErrorResponse({
    required this.message,
    required this.error,
    required this.statusCode,
  });

  factory NotesErrorResponse.fromJson(Map<String, dynamic> json) {
    return NotesErrorResponse(
      message: json['message'] as String,
      error: json['error'] as String,
      statusCode: json['statusCode'] as int,
    );
  }
  final String message;
  final String error;
  final int statusCode;

  Map<String, dynamic> toJson() {
    return {'message': message, 'error': error, 'statusCode': statusCode};
  }
} 