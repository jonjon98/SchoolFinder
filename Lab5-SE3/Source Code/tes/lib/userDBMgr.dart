import 'user.dart';
import 'dart:async';
import 'InterfaceUsrDB.dart';
class userDBMgr
{
  List<USER> _users;
  List<USER> _filterUsers;
  USER _selectedUser;
  bool _isUpdating;
  static Future<bool> addUSR(String username, String password, String email) async
  {
    bool res;
     await UserInterface.addUSER(username,password,email)
        .then((result) {
      if(result)
      {
        res=true;
      }
    });
     return res;
  }
  static Future<String> GETEMAIL(String username) async
  {
    String res;
    await UserInterface.getEMAIL(username)
        .then((result) {
        res=result;
    });
    return res;
  }
  static Future<String> GETPOSTAL(String username) async
  {
    String res;
    await UserInterface.getPOSTAL(username)
        .then((result) {
      res=result;
    });
    return res;
  }
  static Future<bool> LoginCheck(String username, String password) async
  {
    bool res;
    await UserInterface.loginCHECK(username,password)
        .then((result) {
      if(result)
      {
        res=true;
      }
    });
    return res;
  }
  static Future<bool> DelUSR(String username) async
  {
    bool res;
    await UserInterface.deleteUSER(username)
        .then((result) {
      if(result)
      {
        res=true;
      }
    });
    return res;
  }
  static Future<List<USER>> Get_All() async
  {
    List<USER> res;
    await UserInterface.getUsers()
        .then((result) {
       res=result;
    });
    return res;
  }
  static Future<bool> UpdatePassword(String username, String password) async
  {
    bool res;
    await UserInterface.updatePASS(username,password)
        .then((result) {
      if(result)
      {
        res=true;
      }
      print("BACK"+res.toString());

    });
    return res;
  }
  static Future<bool> UpdateEmail(String username, String email) async
  {
    bool res;
    await UserInterface.updateEMAIL(username,email)
        .then((result) {
      if(result)
      {
        res=true;
      }
    });
    return res;
  }
  static Future<bool> UpdatePostal(String username, String postal) async
  {
    bool res;
    await UserInterface.updatePOSTAL(username,postal)
        .then((result) {
      if(result)
      {
        res=true;
      }
    });
    return res;
  }
  static Future<bool> UpdateUnits(String username, String units) async
  {
    bool res;
    await UserInterface.updateUNITS(username,units)
        .then((result) {
      if(result)
      {
        res=true;
      }
    });
    return res;
  }
}