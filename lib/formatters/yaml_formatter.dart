import 'package:json2yaml/json2yaml.dart' as yaml;
import 'package:data_processor/formatters/formatter.dart';

class YamlFormatter extends DataFormatter {
  YamlFormatter(data, int indent) : super(data, indent);

  @override
  Future<String> format() async {
    final result = yaml.json2yaml(data);
    return result;
  }
}
