import 'package:data_processor/data_processor_options.dart';
import 'package:data_processor/formatters/csv_formatter.dart';
import 'package:data_processor/formatters/formatter.dart';
import 'package:data_processor/formatters/json_formatter.dart';
import 'package:data_processor/formatters/template_formatter.dart';
import 'package:data_processor/formatters/tsv_formatter.dart';
import 'package:data_processor/formatters/xml_formatter.dart';
import 'package:data_processor/formatters/yaml_formatter.dart';
import 'package:data_processor/parsers/csv_parser.dart';
import 'package:data_processor/parsers/json_parser.dart';
import 'package:data_processor/parsers/parser.dart';
import 'package:data_processor/parsers/tsv_parser.dart';
import 'package:data_processor/parsers/xml_parser.dart';
import 'package:data_processor/parsers/yaml_parser.dart';
import 'package:jmespath/jmespath.dart' as jmespath;

class DataProcessor {
  static const int defaultOutputIndent = DataFormatter.defaultIndent;

  final String data;
  final String query;
  final String inputFormat;
  late final String outputFormat;
  final String? outputTemplate;
  final int outputIndent;
  final DataProcessorOptions options;

  DataProcessor({
    required this.data,
    this.query = '',
    required this.inputFormat,
    String? outputFormat,
    this.outputTemplate,
    this.outputIndent = defaultOutputIndent,
    this.options = const DataProcessorOptions(),
  }) {
    this.outputFormat = outputFormat ?? inputFormat;
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

      case 'tsv':
        parser = TSVParser(
          data,
          // rowSeparator: options.inputTSV.rowSeparator,
          // textQuote: options.inputTSV.textQuote,
          // headers: options.inputTSV.headers,
          // flatHeaders: options.inputTSV.flatHeaders,
        );
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
          // headers: options.outputCSV.headers, // TODO:
        );
        break;

      case 'tsv':
        formatter = TSVFormatter(
          data,
          outputIndent,
          rowSeparator: options.outputTSV.rowSeparator,
          textQuote: options.outputTSV.textQuote,
          // headers: options.outputTSV.headers, // TODO:
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
