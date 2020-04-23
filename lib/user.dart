class User{
  String username;
  String password;
  String token;
  User({this.username, this.password, this.token});
 factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
      token: json['token'],
    );
  }
}