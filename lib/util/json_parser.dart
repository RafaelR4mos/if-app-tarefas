import 'dart:convert';

import 'package:http/http.dart' as http;

class JsonParser {
  static dynamic parseJsonUtf8(http.Response response) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}
