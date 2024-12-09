class UserModel {
  final String username;
  final String email;
  final String userID;
  String? photoUrl;
  String? phoneNumber;

  UserModel({
    required this.username,
    required this.email,
    required this.userID,
    this.photoUrl,
    this.phoneNumber
  });
}