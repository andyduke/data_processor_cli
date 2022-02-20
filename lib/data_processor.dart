import 'package:data_processor/options/data_processor_options.dart';
import 'package:data_processor/formatters/csv_formatter.dart';
import 'package:data_processor/formatters/formatter.dart';
import 'package:data_processor/formatters/json_formatter.dart';
import 'package:data_processor/formatters/template_formatter.dart';
import 'package:data_processor/formatters/toml_formatter.dart';
import 'package:data_processor/formatters/xml_formatter.dart';
import 'package:data_processor/formatters/yaml_formatter.dart';
import 'package:data_processor/parsers/csv_parser.dart';
import 'package:data_processor/parsers/json_parser.dart';
import 'package:data_processor/parsers/parser.dart';
import 'package:data_processor/parsers/toml_parser.dart';
import 'package:data_processor/parsers/xml_parser.dart';
import 'package:data_processor/parsers/yaml_parser.dart';
import 'package:jmespath/jmespath.dart' as jmespath;

class DataProcessor {
  static const int defaultOutputIndent = DataFormatter.defaultIndent;

  final String data;
  late final String query;
  late final String inputFormat;
  late final String outputFormat;
  late final String? outputTemplate;
  late final int outputIndent;
  final DataProcessorOptions options;

  DataProcessor({
    required this.data,
    this.outputTemplate,
    required this.options,
  }) {
    query = options.query;
    inputFormat = options.inputFormat;
    outputFormat = options.outputFormat;
    outputIndent = options.outputIndent ?? defaultOutputIndent;
  }

  Future<String> process() async {
    final data = await _parseInput();
    final result = (query.isNotEmpty && query != '.') ? jmespath.search(query, data) : data;
    final resultData = await _formatOutput(result);
    return resultData;
  }

  Future<dynamic> _parseInput() async {
    late Parser parser;
    switch (inputFormat) {
      case 'json':
        parser = JSONParser(data);
        break;

      case 'yaml':
        parser = YamlParser(data);
        break;

      case 'xml':
        parser = XMLParser(data);
        break;

      case 'csv':
        parser = CSVParser(
          data,
          columnSeparator: options.inputCSV.columnSeparator,
          rowSeparator: options.inputCSV.rowSeparator,
          textQuote: options.inputCSV.textQuote,
          headers: options.inputCSV.headers,
          flatHeaders: options.inputCSV.flatHeaders,
        );
        break;

      case 'toml':
        parser = TomlParser(data);
        break;

      default:
        throw Exception('Error: unknown input format "$inputFormat".');
    }

    final result = await parser.parse();
    return result;
  }

  Future<String> _formatOutput(dynamic data) async {
    late DataFormatter formatter;
    switch (outputFormat) {
      case 'json':
        formatter = JSONFormatter(data, outputIndent);
        break;

      case 'yaml':
        formatter = YamlFormatter(data, outputIndent);
        break;

      case 'xml':
        formatter = XMLFormatter(data, outputIndent);
        break;

      case 'csv':
        formatter = CSVFormatter(
          data,
          outputIndent,
          columnSeparator: options.outputCSV.columnSeparator,
          rowSeparator: options.outputCSV.rowSeparator,
          textQuote: options.outputCSV.textQuote,
          headers: options.outputCSV.headers,
        );
        break;

      case 'toml':
        formatter = TomlFormatter(
          data,
          outputIndent,
          root: options.outputToml.root,
        );
        break;

      case 'template':
        if (outputTemplate == null) {
          throw Exception('Error: output template is not specified.');
        }
        formatter = TemplateFormatter(data, outputTemplate!);
        break;

      default:
        throw Exception('Error: unknown output format "$outputFormat".');
    }

    final result = await formatter.format();
    return result;
  }
}
