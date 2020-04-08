class UserModel {
  final String email;
  final String password;

  UserModel.fromJson(Map<String, dynamic> parsedJson)
      : email = parsedJson['email'],
        password = parsedJson['password'];
}
