
class Rating {
  String AVG;
  String TEXT;
  Rating({this.TEXT, this.AVG});
  factory Rating.fromJson(Map<String,dynamic> json){
    return Rating(TEXT: json['Text'] as String,AVG: json['AVG'] as String);
  }
}