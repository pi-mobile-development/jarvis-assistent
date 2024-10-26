class UserModel {
  final String username;
  final String email;
  String? photoUrl;

  UserModel({
    required this.username,
    required this.email,
    this.photoUrl
  });
}