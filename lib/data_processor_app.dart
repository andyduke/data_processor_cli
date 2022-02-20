import 'dart:io';
import 'package:data_processor/data_processor.dart';
import 'package:data_processor/data_processor_options.dart';
import 'package:data_processor/options/csv/input.dart';
import 'package:data_processor/options/csv/output.dart';
import 'package:data_processor/options/toml/output.dart';
import 'package:io/io.dart' show ExitCode;
import 'package:data_processor/cli_app.dart';
import 'package:path/path.dart' as p;

import 'package:cli_util/cli_logging.dart';

class DataProcessorApp extends CliApp {
  @override
  final String name = 'DataProcessor';

  @override
  final String version = '1.0';

  @override
  final String copyright = 'Copyright (C) 2022 Andy Chentsov <chentsov@gmail.com>';

  @override
  String get description => 'Flexible command-line data processor.';

  String get catCommand => Platform.isWindows ? 'type' : 'cat';

  @override
  late final String usage =
      '''Usage: $executable "<query>" [<filename>] [options] > output_file
       $catCommand <filename> | $executable "<query>" [options] > output_file
''';

  final List<String> inputFormats = ['json', 'yaml', 'xml', 'csv', 'toml'];
  final List<String> outputFormats = ['json', 'yaml', 'xml', 'csv', 'toml', 'template'];

  String query = '';
  String? inputFilename;
  String? outputFilename;
  String inputFormat = 'auto';
  String outputFormat = 'auto';
  String? template;
  int? outputIndent;

  InputCSVOptions? inputCSVOptions;
  OutputCSVOptions? outputCSVOptions;
  OutputTomlOptions? outputTomlOptions;

  static const int separatorWidth = 30;
  final ansi = Ansi(stdout.supportsAnsiEscapes);

  DataProcessorApp([List<String> args = const []]) : super(args);

  String buildSeparator(String text) {
    final len = text.length;
    final trailing = ''.padRight(separatorWidth - 4 - 1 - len, '-');
    final result = '\n--- ${ansi.emphasized(text)} $trailing\n';
    return result;
  }

  @override
  void setupOptions() {
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
  void displayIntro() {
    if (!ready) {
      super.displayIntro();
    } else {
      if (verbose) {
        super.displayIntro();
      }
    }
  }

  @override
  bool handleArguments() {
    super.handleArguments();

    if (arguments.wasParsed('help')) {
      return false;
    }

    // print('$argsRest');

    if (argsRest.isNotEmpty) {
      query = argsRest[0];

      if (argsRest.length > 1) {
        inputFilename = argsRest[1];
      }
    }

    inputFormat = arguments['input'] ?? inputFormat;
    outputFormat = arguments['output'] ?? outputFormat;
    template = arguments['template'];
    outputFilename = arguments['output-file'];
    outputIndent = int.tryParse(arguments['indent']) ?? DataProcessor.defaultOutputIndent;

    if (inputFormat == 'csv') {
      inputCSVOptions = InputCSVOptions.fromArguments(arguments);
    }

    if (outputFormat == 'csv') {
      outputCSVOptions = OutputCSVOptions.fromArguments(arguments);
    }

    if (outputFormat == 'toml') {
      outputTomlOptions = OutputTomlOptions.fromArguments(arguments);
    }

    return argsRest.isNotEmpty;
  }

  @override
  void preRun() {
    detectFormats();
  }

  void detectFormats() {
    if (inputFormat == 'auto') {
      if (inputFilename == null) {
        logger.stderr('Error: "Input format" must be specified because data is read from stdin.');
        exitApp(ExitCode.data.code);
      }

      final inputExt = p.extension(inputFilename!);
      switch (inputExt) {
        case '.json':
          inputFormat = 'json';
          break;

        case '.yaml':
        case '.yml':
          inputFormat = 'yaml';
          break;

        case '.xml':
          inputFormat = 'xml';
          break;

        case '.csv':
          inputFormat = 'csv';
          break;

        case '.toml':
          inputFormat = 'toml';
          break;

        default:
          logger.stderr(
            'Error: It is not possible to determine "Input format" from the filename, you must specify it with an option --${parser.findByNameOrAlias('input')?.name}.',
          );
          exitApp(ExitCode.data.code);
          break;
      }
    }

    if (outputFormat == 'auto') {
      outputFormat = inputFormat;
    }
  }

  @override
  void displaySummary() {
    logger.trace(' - Query: $query');

    if (inputFilename == null) {
      logger.trace(' - Input: stdin ($inputFormat)');
    } else {
      logger.trace(' - Input: $inputFilename ($inputFormat)');
    }
    // logger.trace(' - Input format: $inputFormat');

    inputCSVOptions?.displaySummary(logger.trace);

    if (outputFilename == null) {
      logger.trace(' - Output: stdout ($outputFormat)');
    } else {
      logger.trace(' - Output: $outputFilename ($outputFormat)');
    }
    // logger.trace(' - Output format: $outputFormat');
    logger.trace(' - Output indent: $outputIndent');

    outputCSVOptions?.displaySummary(logger.trace);

    outputTomlOptions?.displaySummary(logger.trace);

    logger.trace('');
  }

  @override
  Future<int> runApp() async {
    final data = (inputFilename == null) ? (stdin.readLineSync() ?? '') : (await File(inputFilename!).readAsString());
    final outputTemplate = (template != null) ? (await File(template!).readAsString()) : null;
    final processor = DataProcessor(
      data: data,
      query: query,
      inputFormat: inputFormat,
      outputFormat: outputFormat,
      outputTemplate: outputTemplate,
      outputIndent: outputIndent!,
      options: DataProcessorOptions(
        inputCSV: inputCSVOptions ?? const InputCSVOptions(),
        outputCSV: outputCSVOptions ?? const OutputCSVOptions(),
        outputToml: outputTomlOptions ?? const OutputTomlOptions(),
      ),
    );

    final output = await processor.process();

    logger.write(output);

    if (verbose) {
      logger.write('\n');
    }

    return 0;
  }
}
