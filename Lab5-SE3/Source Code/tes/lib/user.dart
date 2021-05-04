class USER{
  String username;
  String password;
  String email;
  String postalCode;
  String units;
  USER({this.username, this.password, this.email, this.postalCode, this.units});
  factory USER.fromJson(Map<String,dynamic> json){
    return USER(username: json['Username'] as String,password: json['Password'] as String,
        email: json['Email'] as String, postalCode: json['PostalCode'] as String, units: json['Units'] as String);
  }
}