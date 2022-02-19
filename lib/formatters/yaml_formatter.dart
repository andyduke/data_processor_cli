// import 'package:json2yaml/json2yaml.dart' as yaml;
import 'package:yaml_writer/yaml_writer.dart' as yaml;
import 'package:data_processor/formatters/formatter.dart';

class YamlFormatter extends DataFormatter {
  YamlFormatter(data, int indent) : super(data, indent);

  @override
  Future<String> format() async {
    // final yamlData = (data is! Map) ? {'data': data} : data;
    // final result = yaml.json2yaml(yamlData);
    final result = yaml.YAMLWriter().write(data).trim();
    return result;
  }
}
