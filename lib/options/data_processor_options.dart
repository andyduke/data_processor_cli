import 'dart:io';
import 'package:cli_util/cli_logging.dart';

import 'package:args/args.dart';
import 'package:data_processor/data_processor.dart';
import 'package:data_processor/options/csv/input.dart';
import 'package:data_processor/options/csv/output.dart';
import 'package:data_processor/options/summary_output.dart';
import 'package:data_processor/options/toml/output.dart';

class DataProcessorOptions implements SummaryOutput {
  static const String defaultQuery = '';
  static const String defaultInputFormat = 'auto';
  static const String defaultOutputFormat = 'auto';

  static const int separatorWidth = 30;
  static final ansi = Ansi(stdout.supportsAnsiEscapes);

  static final List<String> inputFormats = ['json', 'yaml', 'xml', 'csv', 'toml'];
  static final List<String> outputFormats = ['json', 'yaml', 'xml', 'csv', 'toml', 'template'];

  final String query;
  final String? inputFilename;
  final String? outputFilename;
  final String inputFormat;
  final String outputFormat;
  final String? template;
  final int? outputIndent;

  final InputCSVOptions inputCSV;
  final OutputCSVOptions outputCSV;
  final OutputTomlOptions outputToml;

  const DataProcessorOptions({
    this.query = defaultQuery,
    this.inputFilename,
    this.outputFilename,
    required this.inputFormat,
    String? outputFormat,
    this.template,
    this.outputIndent,

    // Nested Options
    this.inputCSV = const InputCSVOptions(),
    this.outputCSV = const OutputCSVOptions(),
    this.outputToml = const OutputTomlOptions(),
  }) : outputFormat = outputFormat ?? inputFormat;

  DataProcessorOptions.fromArguments({
    required this.query,
    this.inputFilename,
    this.outputFilename,
    required String inputFormat,
    String? outputFormat,
    required ArgResults arguments,
  })  : inputFormat = arguments.wasParsed('input') ? arguments['input'] : inputFormat,
        outputFormat = arguments.wasParsed('output')
            ? arguments['output']
            : outputFormat ?? (arguments.wasParsed('input') ? arguments['input'] : inputFormat),
        template = arguments['template'],
        outputIndent = int.tryParse(arguments['indent']) ?? DataProcessor.defaultOutputIndent,

        // Nested Options
        inputCSV = InputCSVOptions.fromArguments(arguments),
        outputCSV = OutputCSVOptions.fromArguments(arguments),
        outputToml = OutputTomlOptions.fromArguments(arguments);

  static String buildSeparator(String text) {
    final len = text.length;
    final trailing = ''.padRight(separatorWidth - 4 - 1 - len, '-');
    final result = '\n--- ${ansi.emphasized(text)} $trailing\n';
    return result;
  }

  static void cliOptions(ArgParser parser) {
    parser.addSeparator(buildSeparator('Input and Output'));

    parser.addOption(
      'input',
      abbr: 'i',
      defaultsTo: 'auto',
      help: 'Input format (default: detect from filename extension)',
      allowed: inputFormats,
      valueHelp: 'format',
    );

    parser.addOption(
      'output',
      abbr: 'o',
      defaultsTo: 'auto',
      help: 'Output format (default: input format)',
      allowed: outputFormats,
      valueHelp: 'format',
    );

    parser.addOption(
      'indent',
      abbr: 'n',
      defaultsTo: '${DataProcessor.defaultOutputIndent}',
      help: 'Output indent',
      valueHelp: 'indent',
    );

    parser.addOption(
      'output-file',
      abbr: 'f',
      help: 'Output to <file> instead of stdout',
      valueHelp: 'file',
    );

    parser.addOption(
      'template',
      abbr: 't',
      help: 'Output template file (output=template only)',
      valueHelp: 'template file',
    );

    parser.addSeparator(buildSeparator('CSV Input options'));
    InputCSVOptions.cliOptions(parser);

    parser.addSeparator(buildSeparator('CSV Output options'));
    OutputCSVOptions.cliOptions(parser);

    parser.addSeparator(buildSeparator('Toml Output options'));
    OutputTomlOptions.cliOptions(parser);

    parser.addSeparator(buildSeparator('Other'));

    parser.addFlag(
      'help',
      abbr: 'h',
      help: 'Print this usage information',
      negatable: false,
    );
  }

  @override
  void displaySummary(void Function(String message) out) {
    out(' - Query: $query');

    if (inputFilename == null) {
      out(' - Input: stdin ($inputFormat)');
    } else {
      out(' - Input: $inputFilename ($inputFormat)');
    }
    // out(' - Input format: $inputFormat');

    inputCSV.displaySummary(out);

    if (outputFilename == null) {
      out(' - Output: stdout ($outputFormat)');
    } else {
      out(' - Output: $outputFilename ($outputFormat)');
    }
    // out(' - Output format: $outputFormat');
    out(' - Output indent: $outputIndent');

    outputCSV.displaySummary(out);

    outputToml.displaySummary(out);

    out('');
  }
}
