class FAVOURITES
{
  String username;
  String SchoolName;
  FAVOURITES({this.username,this.SchoolName});
  factory FAVOURITES.fromJson(Map<String,dynamic> json){
    return FAVOURITES(username: json['Username'] as String,SchoolName: json['SchoolName'] as String);
  }
}