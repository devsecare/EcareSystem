import 'package:http/http.dart' as http;

class EmailAPi {
  Future sendEmail(String body, String subject) async {
    var url = Uri.parse('https://ecareinfoway.com/emailer.php');

    var data = {
      "key": "yMf4QErrZMeoT9ztrvdcGu0pMNlbFOyz",
      "body": body,
      "subject": subject,
    };
    try {
      var response = await http.post(
        url,
        body: data,
      );
      // ignore: avoid_print
      print(response.body);

// ignore: empty_catches
    } catch (e) {
      // ignore: avoid_print
      print("check EmailApi class error");
    }
  }
}
