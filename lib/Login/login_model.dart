class UserModel {
  final String username;
  final String email;
  final String userID;
  String? photoUrl;

  UserModel({
    required this.username,
    required this.email,
    required this.userID,
    this.photoUrl
  });
}