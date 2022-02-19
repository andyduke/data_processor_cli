import 'package:args/args.dart';
import 'package:csv/csv.dart';
import 'package:data_processor/options/summary_output.dart';

class InputTSVOptions implements SummaryOutput {
  final List<String>? headers;
  final bool flatHeaders;
  final String rowSeparator;
  final String textQuote;

  const InputTSVOptions({
    this.headers,
    this.flatHeaders = false,
    this.rowSeparator = defaultEol,
    this.textQuote = defaultTextDelimiter,
  });

  InputTSVOptions.fromArguments(ArgResults arguments)
      : headers = arguments['input-tsv-headers'],
        flatHeaders = arguments.wasParsed('input-tsv-flat-headers'),
        rowSeparator = arguments['input-tsv-row-sep'] ?? defaultEol,
        textQuote = arguments['input-tsv-text-quote'] ?? defaultTextDelimiter;

  static void cliOptions(ArgParser parser) {
    parser.addOption(
      'input-tsv-row-sep',
      help: 'TSV row separator',
      valueHelp: 'separator',
      defaultsTo: defaultEol.replaceAll("\n", r"\n").replaceAll("\r", r"\r"),
    );

    parser.addOption(
      'input-tsv-text-quote',
      help: 'TSV text quote character',
      valueHelp: 'quote',
      defaultsTo: defaultTextDelimiter,
    );

    parser.addOption(
      'input-tsv-headers',
      help: 'Headers of TSV data\n(example "field 1","field 2")',
      valueHelp: 'headers',
    );

    parser.addFlag(
      'input-tsv-flat-headers',
      help:
          'Don\'t interpret dots (.) and square brackets in header fields as nested object or array identifiers at all',
      defaultsTo: false,
      negatable: false,
    );
  }

  @override
  void displaySummary(void Function(String message) out) {
    out(' - Input TSV row separator: $rowSeparator');
    out(' - Input TSV text quote: $textQuote');
    out(' - Input TSV headers: $headers');
    out(' - Input TSV flat headers: ${flatHeaders ? 'yes' : 'no'}');
  }
}
