class User{
  String username;
  String password;
  String token;
  String nom;
  String prenom;
  String telephon;
  String email;
  String dateNaissance;
  String roles;
  String adresse;
  User({
    this.username,
    this.password, 
    this.token,
    this.nom,
    this.prenom,
    this.dateNaissance,
    this.email,
    this.roles,
    this.telephon,
    this.adresse
     });
 factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
      token: json['token'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      dateNaissance: json['dateNaissance'],
      telephon: json['telephon'],
      roles: json['roles'],
      adresse: json['adresse'],
    );
  }
}