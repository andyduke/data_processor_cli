import 'package:args/args.dart';
import 'package:csv/csv.dart';
import 'package:data_processor/options/summary_output.dart';
import 'package:data_processor/utils/string.dart';

class OutputCSVOptions implements SummaryOutput {
  final List<String>? headers;
  final String columnSeparator;
  final String rowSeparator;
  final String textQuote;

  const OutputCSVOptions({
    this.headers,
    this.columnSeparator = defaultFieldDelimiter,
    this.rowSeparator = defaultEol,
    this.textQuote = defaultTextDelimiter,
  });

  OutputCSVOptions.fromArguments(ArgResults arguments)
      : headers = arguments['output-csv-headers'],
        columnSeparator = StringEscape(arguments['output-csv-col-sep'])?.unescape() ?? defaultFieldDelimiter,
        rowSeparator = StringEscape(arguments['output-csv-row-sep'])?.unescape() ?? defaultEol,
        textQuote = arguments['output-csv-text-quote'] ?? defaultTextDelimiter;

  static void cliOptions(ArgParser parser) {
    parser.addOption(
      'output-csv-col-sep',
      help: 'CSV column separator',
      valueHelp: 'separator',
      defaultsTo: defaultFieldDelimiter,
    );

    parser.addOption(
      'output-csv-row-sep',
      help: 'CSV row separator',
      valueHelp: 'separator',
      defaultsTo: defaultEol.escape(),
    );

    parser.addOption(
      'output-csv-text-quote',
      help: 'CSV text quote character',
      valueHelp: 'quote',
      defaultsTo: defaultTextDelimiter,
    );

    parser.addOption(
      'output-csv-headers',
      help: 'Header columns in order \n(example "field 1","field 2")',
      valueHelp: 'headers',
    );
  }

  @override
  void displaySummary(void Function(String message) out) {
    out(' - Output CSV column separator: ${columnSeparator.escape()}');
    out(' - Output CSV row separator: ${rowSeparator.escape()}');
    out(' - Output CSV text quote: $textQuote');
    if (headers != null) {
      out(' - Output CSV headers: $headers');
    }
  }
}
