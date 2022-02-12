import 'package:yaml/yaml.dart' as yaml;
import 'package:data_processor/parsers/parser.dart';

class YamlParser extends Parser {
  YamlParser(String data) : super(data);

  @override
  Future<dynamic> parse() async {
    final result = yaml.loadYaml(data);
    return result;
  }
}
