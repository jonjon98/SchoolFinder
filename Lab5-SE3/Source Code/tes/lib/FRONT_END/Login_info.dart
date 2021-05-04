import '../BACK_END_INTERFACE.dart';
class Login_info
{
  String username;
  String Password;
  String email;
  Login_info(String userName, String password)
  {
    this.username=userName;
    this.Password=password;
  }
  Future<String> Get_Email(String username) async
  {
    String result;
    await BACK_END.GETEMAIL(username).then((res)
    {
      result=res;
    }
    );
    return result;
  }
}
class More_info extends Login_info
{
  String SchoolName;
  String username;
  String Password;
  More_info(this.username, this.Password,this.SchoolName) : super(username, Password);

}

class Advanced_info extends Login_info
{
  String level;
  String subject;
  String ccaCategory;
  String ccaName;
  String username;
  String Password;

  Advanced_info(this.username, this.Password,this.level, this.subject, this.ccaName, this.ccaCategory) : super(username, Password);

  // Advanced_info(String userName, String password, String level, String subject, String ccaCategory, String ccaName)
  // {
  //   this.username = userName;
  //   this.Password = password;
  //   this.level = level;
  //   this.subject = subject;
  //   this.ccaCategory = ccaCategory;
  //   this.ccaName = ccaName;
  // }

}