class UserModel {
  late String email;
  final DateTime createdAt;

  UserModel({
    required this.email,
    required this.createdAt,
  });

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        email: json['email'] ?? '',
        createdAt: DateTime.parse(json['createdAt'].toDate().toString()),
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'createdAt': createdAt,
      };
}
