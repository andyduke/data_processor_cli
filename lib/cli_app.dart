import 'dart:io';
import 'package:io/io.dart' show ExitCode;
import 'package:cli_util/cli_logging.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;

abstract class CliApp {
  abstract final String name;
  abstract final String version;
  abstract final String copyright;
  abstract final String usage;

  String get intro => '$name $version, $copyright';

  String? _executable;
  String get executable => _executable ??= p.basenameWithoutExtension(Platform.executable);

  // ---

  bool silent = false;
  bool verbose = false;

  // ---

  static const int usageIndent = 2;
  static int get outputWidth => stdout.hasTerminal ? stdout.terminalColumns : 80;

  final parser = ArgParser(usageLineLength: outputWidth - usageIndent);
  late Logger logger;

  late ArgResults arguments;
  late List<String> argsRest;

  bool ready = false;

  CliApp([List<String> args = const []]) {
    // Setup Parser's Options
    setupOptions();
    setupDefaultOptions();

    // Parse args
    arguments = parser.parse(args);
    argsRest = arguments.rest.toList(growable: true);

    ready = handleArguments();

    setupLogger();

    handleVersion();
  }

  void setupOptions();

  void setupDefaultOptions() {
    parser.addFlag(
      'silent',
      abbr: 's',
      defaultsTo: false,
      negatable: false,
      help: 'Silent output',
    );

    parser.addFlag(
      'verbose',
      abbr: 'v',
      defaultsTo: false,
      negatable: false,
      help: 'Verbose output',
    );

    parser.addFlag(
      'version',
      defaultsTo: false,
      negatable: false,
      help: 'Prints the version of the $name',
    );
  }

  void setupLogger() {
    logger = verbose ? Logger.verbose(logTime: false) : Logger.standard();
  }

  bool handleArguments() {
    silent = arguments['silent'];
    verbose = arguments['verbose'] && !silent;

    return true;
  }

  void handleVersion() {
    if (arguments['version']) {
      displayVersion();
      exitApp(ExitCode.usage.code - 1);
    }
  }

  void displayIntro() {
    if (!silent) {
      logger.write('$intro\n\n');
    }
  }

  void displayUsage() {
    final usageText = '''$usage
Options:
${_indent('${parser.usage}\n', indent: usageIndent)}
''';

    logger.write(usageText);

    exitApp(ExitCode.usage.code);
  }

  void displaySummary() {}

  void displayVersion() {
    logger.write('$version\n');
  }

  void preRun();

  Future<int> runApp();

  Future<void> run() async {
    displayIntro();

    if (!ready) {
      displayUsage();
      return;
    }

    preRun();

    if (verbose) {
      displaySummary();
    }

    var exitCode = await runApp();
    exitApp(exitCode);
  }

  void exitApp(int exitCode) {
    exit(exitCode);
  }

  String _indent(String text, {int indent = 2}) {
    var result = text.replaceAllMapped(RegExp(r'^([^\S\r\n]*)', multiLine: true), (m) {
      if (m.groupCount > 0) {
        // return m[1]!.padLeft(indent);
        return ''.padLeft(indent) + m[1]!;
      } else {
        return m.input;
      }
    });

    return result;
  }
}
