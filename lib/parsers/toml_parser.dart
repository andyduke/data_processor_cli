import 'package:data_processor/parsers/parser.dart';
import 'package:toml/toml.dart';

class TomlParser extends Parser {
  TomlParser(String data) : super(data);

  @override
  Future<dynamic> parse() async {
    final result = TomlDocument.parse(data).toMap();
    return result;
  }
}
