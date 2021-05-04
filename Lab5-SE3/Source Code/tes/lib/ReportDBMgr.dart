import 'package:tes/InterfaceReportDB.dart';
import 'package:tes/Report.dart';
import 'dart:async';
class reportDBMgr
{
  List<REPORT> _reports;
  REPORT _selectedReport;
  bool _isUpdating;
  static Future<bool> addREPORT(String username, String message) async
  {
    bool res;
    await ReportInterface.addReport(username,message)
        .then((result) {
      if(result)
      {
        res=true;
      }
    });
    return res;
  }
  static Future<List<REPORT>> Get_All() async
  {
    List<REPORT> res;
    await ReportInterface.getReport()
        .then((result) {
      res=result;
    });
    return res;
  }

}