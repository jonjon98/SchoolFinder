class REPORT {
  String username;
  String message;
  REPORT({this.username, this.message});
  factory REPORT.fromJson(Map<String,dynamic> json){
    return REPORT(username: json['Username'] as String,message: json['Message'] as String);
  }
}