import 'dart:convert';
import 'package:data_processor/parsers/parser.dart';

class JSONParser extends Parser {
  JSONParser(String data) : super(data);

  @override
  Future<dynamic> parse() async {
    final result = json.decode(data);
    return result;
  }
}
