import 'package:args/args.dart';
import 'package:csv/csv.dart';
import 'package:data_processor/options/summary_output.dart';

class OutputTSVOptions implements SummaryOutput {
  final List<String>? headers;
  final String rowSeparator;
  final String textQuote;

  const OutputTSVOptions({
    this.headers,
    this.rowSeparator = defaultEol,
    this.textQuote = defaultTextDelimiter,
  });

  OutputTSVOptions.fromArguments(ArgResults arguments)
      : headers = arguments['output-tsv-headers'],
        rowSeparator = arguments['output-tsv-row-sep'] ?? defaultEol,
        textQuote = arguments['output-tsv-text-quote'] ?? defaultTextDelimiter;

  static void cliOptions(ArgParser parser) {
    parser.addOption(
      'output-tsv-row-sep',
      help: 'TSV row separator',
      valueHelp: 'separator',
      defaultsTo: defaultEol.replaceAll("\n", r"\n").replaceAll("\r", r"\r"),
    );

    parser.addOption(
      'output-tsv-text-quote',
      help: 'TSV text quote character',
      valueHelp: 'quote',
      defaultsTo: defaultTextDelimiter,
    );

    parser.addOption(
      'output-tsv-headers',
      help: 'Header columns in order \n(example "field 1","field 2")',
      valueHelp: 'headers',
    );
  }

  @override
  void displaySummary(void Function(String message) out) {
    out(' - Output TSV row separator: $rowSeparator');
    out(' - Output TSV text quote: $textQuote');
    out(' - Output TSV headers: $headers');
  }
}
