class COMMENT {
  String username;
  String Message;
  String rating;
  String SchoolName;
  COMMENT({this.username, this.Message,this.SchoolName, this.rating});
  factory COMMENT.fromJson(Map<String,dynamic> json){
    return COMMENT(username: json['Username'] as String,Message: json['Message'] as String,
        SchoolName: json['SchoolName'] as String, rating: json['Rating'] as String);
  }
}