class SiteNoteEntry {
  SiteNoteEntry({
    required this.id,
    required this.noteTitle,
    required this.noteContent,
    required this.company,
    required this.username,
    required this.createdAt,
  });

  factory SiteNoteEntry.fromJson(Map<String, dynamic> json) {
    return SiteNoteEntry(
      id: json['id'] as int,
      noteTitle: json['noteTitle'] as String,
      noteContent: json['noteContent'] as String,
      company: json['company'] as String,
      username: json['username'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  final int id;
  final String noteTitle;
  final String noteContent;
  final String company;
  final String username;
  final String createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'noteTitle': noteTitle,
      'noteContent': noteContent,
      'company': company,
      'username': username,
      'createdAt': createdAt,
    };
  }
} 