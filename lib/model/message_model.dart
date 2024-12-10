class Message {
  late String id;
  final String userid;
  late String message;
  final DateTime createdAt;

  Message({
    this.id = '',
    required this.userid,
    required this.message,
    required this.createdAt,
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
        id: json['id'] ?? '',
        userid: json['userid'],
        message: json['message'] ?? '',
        createdAt: DateTime.parse(json['createdAt'].toDate().toString()),
      );

  Map<String, dynamic> toJson() => {
        'userid': userid,
        'message': message,
        'createdAt': createdAt,
      };
}
