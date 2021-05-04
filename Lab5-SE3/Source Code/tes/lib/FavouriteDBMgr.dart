import 'package:tes/Favourites.dart';
import 'package:tes/InterfaceFavouritesDB.dart';
import 'dart:async';
class FavouriteMgr
{
  static Future<bool> addFavourite(String username,String SchoolName) async
  {
    bool res;
    await FavouritesInterface.addFAVOURITES(username, SchoolName)
        .then((result) {
      if(result)
      {
        res=true;
      }
    });
    return res;
  }
  static Future<List<FAVOURITES>> GetAllForOneUser(String username) async
  {
    List<FAVOURITES> res;
    await FavouritesInterface.getFavouritesForOneUSER(username)
        .then((result) {
      res=result;
    });
    return res;
  }
  static Future<bool> DELFAV(String username, String SchoolName) async
  {
    bool res;
    await FavouritesInterface.deleteFavourite(username, SchoolName)
        .then((result) {
      if(result)
      {
        res=true;
      }
    });
    return res;
  }
}