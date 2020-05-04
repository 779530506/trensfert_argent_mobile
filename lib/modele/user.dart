class User{
  String username, password, token, nom, prenom, telephon, email, role, adresse;
  bool isActive;
  DateTime dateNaissance;
  User({
    this.username,
    this.password, 
    this.token,
    this.nom,
    this.prenom,
    this.dateNaissance,
    this.email,
    this.role,
    this.telephon,
    this.adresse,
    this.isActive
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
      role: json['role'],
      adresse: json['adresse'],
      isActive: json['isActive']
    );
  }
}