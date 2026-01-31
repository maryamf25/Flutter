class VoiceNote {
  final String id;
  String title;
  String content;
  final DateTime createdAt;
  DateTime updatedAt;
  String? audioFilePath;

  VoiceNote({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.audioFilePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'audioFilePath': audioFilePath,
    };
  }

  factory VoiceNote.fromMap(Map<String, dynamic> map) {
    return VoiceNote(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      audioFilePath: map['audioFilePath'],
    );
  }
}
