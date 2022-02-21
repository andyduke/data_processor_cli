import 'dart:io';
import 'package:data_processor/data_processor.dart';
import 'package:data_processor/options/data_processor_options.dart';
import 'package:io/io.dart' show ExitCode;
import 'package:data_processor/cli_app.dart';
import 'package:path/path.dart' as p;

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
  late final String usage = '''Usage: $executable "<query>" [<filename>] [options] > output_file
       $catCommand <filename> | $executable "<query>" [options] > output_file
''';

  String query = DataProcessorOptions.defaultQuery;
  String? inputFilename;
  String inputFormat = DataProcessorOptions.defaultInputFormat;
  String outputFormat = DataProcessorOptions.defaultOutputFormat;
  DataProcessorOptions? options;

  DataProcessorApp([List<String> args = const []]) : super(args);

  @override
  void setupOptions() {
    DataProcessorOptions.cliOptions(parser);
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

    if (argsRest.isNotEmpty) {
      query = argsRest[0];

      if (argsRest.length > 1) {
        inputFilename = argsRest[1];
      }
    }

    return argsRest.isNotEmpty;
  }

  @override
  void preRun() {
    detectFormats();

    options = DataProcessorOptions.fromArguments(
      query: query,
      inputFilename: inputFilename,
      inputFormat: inputFormat,
      outputFormat: outputFormat,
      arguments: arguments,
    );
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

        // case '.xml':
        //   inputFormat = 'xml';
        //   break;

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
    options?.displaySummary(logger.trace);
  }

  @override
  Future<int> runApp() async {
    final data = (options?.inputFilename == null)
        ? (stdin.readLineSync() ?? '')
        : (await File(options!.inputFilename!).readAsString());
    final outputTemplate = (options?.template != null) ? (await File(options!.template!).readAsString()) : null;
    final processor = DataProcessor(
      data: data,
      outputTemplate: outputTemplate,
      options: options!,
    );

    final output = await processor.process();

    logger.write(output);

    if (verbose) {
      logger.write('\n');
    }

    return 0;
  }
}
