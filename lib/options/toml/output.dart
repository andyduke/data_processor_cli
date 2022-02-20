import 'package:args/args.dart';
import 'package:data_processor/formatters/toml_formatter.dart';
import 'package:data_processor/options/summary_output.dart';

class OutputTomlOptions implements SummaryOutput {
  final String? root;

  const OutputTomlOptions({
    this.root,
  });

  OutputTomlOptions.fromArguments(ArgResults arguments) : root = arguments['output-toml-root'];

  static void cliOptions(ArgParser parser) {
    parser.addOption(
      'output-toml-root',
      help: 'The name of the root element if the data is not a dictionary.',
      valueHelp: 'root',
      defaultsTo: TomlFormatter.defaultRoot,
    );
  }

  @override
  void displaySummary(void Function(String message) out) {
    if (root != null) {
      out(' - Output Toml root: $root');
    }
  }
}
