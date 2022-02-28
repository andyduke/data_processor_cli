import 'dart:io';
import 'package:data_processor/commands/command.dart';
import 'package:data_processor/commands/commands.dart';
import 'package:data_processor/commands/option.dart';
import 'package:data_processor/data_processor.dart';
import 'package:data_processor/guides/data_processor_guide.dart';
import 'package:data_processor/guides/jmes_path_guide.dart';
import 'package:data_processor/guides/template_guide.dart';
import 'package:data_processor/markdown.dart';
import 'package:data_processor/options/data_processor_options.dart';
import 'package:io/ansi.dart';
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
  // String get description => 'Flexible command-line data processor.';
  String get description =>
      '''The Data Processor is a tool for converting structured data from one format to another, with the ability to select a portion of a piece of data to convert, or use a template to compose the result.

Supported input and output formats: JSON, Yaml, XML, CSV, TOML.

The output can be generated using a template language similar to [django/liquid template language](https://docs.djangoproject.com/en/4.0/ref/templates/language/).

It is possible to select only a portion of the input data using the [JMESPath](https://jmespath.org/) query language.

For more information, use the **--guide**, **--jmespath-guide** and **--template-guide** options.''';

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
  late MiniCommands commands;

  DataProcessorApp([List<String> args = const []]) : super(args);

  @override
  void setupOptions() {
    commands = MiniCommands(
      commands: [
        MiniCommand(
          name: 'guide',
          description: 'Print the Data Processor Guide in text or markdown format',
          runner: (options) =>
              DataProcessorGuide(logger.write, intro: () => introText).display(options['guide-format'] ?? 'text'),
        ),
        MiniCommand(
          name: 'jmespath-guide',
          description: 'Print the JMSPath Guide in text or markdown format',
          runner: (options) =>
              JMESPathGuide(logger.write, intro: () => introText).display(options['guide-format'] ?? 'text'),
        ),
        MiniCommand(
          name: 'template-guide',
          description: 'Print the Template Guide in text or markdown format',
          runner: (options) =>
              TemplateGuide(logger.write, intro: () => introText).display(options['guide-format'] ?? 'text'),
        ),
      ],
      options: [
        MiniCommandOption(
          name: 'guide-format',
          description: 'Guide format',
          allowed: ['text', 'md', 'html'],
          defaultsTo: 'text',
          valueHelp: 'format',
        ),
      ],
    );

    DataProcessorOptions.cliOptions(parser: parser, commands: commands);
  }

  @override
  void displayIntro() {
    if (!ready) {
      displayIntroText();
    } else {
      if (verbose) {
        displayIntroText();
      }
    }
  }

  String get introText {
    final buffer = StringBuffer();

    if (stdout.supportsAnsiEscapes) {
      buffer.write(white.escape);
    }
    buffer.write(intro);
    if (stdout.supportsAnsiEscapes) {
      buffer.write(resetAll.escape);
    }
    buffer.writeln();
    buffer.writeln();

    return buffer.toString();
  }

  void displayIntroText() {
    logger.write(introText);
  }

  @override
  void displayDescription() {
    final text = renderMarkdownToANSI(description);
    logger.write('$text\n');
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
  void handleFlags() {
    if (commands.run(arguments)) {
      exitApp(ExitCode.usage.code);
    }
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
