import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:math';

class EMAIL {
  static send_Email(String Email, String pass) async {
    String username = 'schoolfinder038@gmail.com';
    String password = 'FUCKLOKE';

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.
    // Create our message.
    final message = Message()
      ..from = Address(username, 'School Finder')
      ..recipients.add(Email)
      ..subject = 'Forgot Password'
      ..text = 'Your new Password is : ' + pass
      ..html = "<h1>Hi,</h1>\n<p>Your new Password is : </p>"+pass;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}