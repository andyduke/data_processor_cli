import 'package:args/args.dart';
import 'package:csv/csv.dart';
import 'package:data_processor/options/summary_output.dart';
import 'package:data_processor/utils/string.dart';

class InputCSVOptions implements SummaryOutput {
  final List<String>? headers;
  final bool flatHeaders;
  final String columnSeparator;
  final String rowSeparator;
  final String textQuote;

  const InputCSVOptions({
    this.headers,
    this.flatHeaders = false,
    this.columnSeparator = defaultFieldDelimiter,
    this.rowSeparator = defaultEol,
    this.textQuote = defaultTextDelimiter,
  });

  InputCSVOptions.fromArguments(ArgResults arguments)
      : headers = arguments['input-csv-headers'],
        flatHeaders = arguments.wasParsed('input-csv-flat-headers'),
        columnSeparator = StringEscape(arguments['input-csv-col-sep'])?.unescape() ?? defaultFieldDelimiter,
        rowSeparator = StringEscape(arguments['input-csv-row-sep'])?.unescape() ?? defaultEol,
        textQuote = arguments['input-csv-text-quote'] ?? defaultTextDelimiter;

  static void cliOptions(ArgParser parser) {
    parser.addOption(
      'input-csv-col-sep',
      help: 'CSV column separator',
      valueHelp: 'separator',
      defaultsTo: defaultFieldDelimiter,
    );

    parser.addOption(
      'input-csv-row-sep',
      help: 'CSV row separator',
      valueHelp: 'separator',
      defaultsTo: defaultEol.escape(),
    );

    parser.addOption(
      'input-csv-text-quote',
      help: 'CSV text quote character',
      valueHelp: 'quote',
      defaultsTo: defaultTextDelimiter,
    );

    parser.addOption(
      'input-csv-headers',
      help: 'Headers of CSV data\n(example "field 1","field 2")',
      valueHelp: 'headers',
    );

    parser.addFlag(
      'input-csv-flat-headers',
      help:
          'Don\'t interpret dots (.) and square brackets in header fields as nested object or array identifiers at all',
      defaultsTo: false,
      negatable: false,
    );
  }

  @override
  void displaySummary(void Function(String message) out) {
    out(' - Input CSV column separator: ${columnSeparator.escape()}');
    out(' - Input CSV row separator: ${rowSeparator.escape()}');
    out(' - Input CSV text quote: $textQuote');
    if (headers != null) {
      out(' - Input CSV headers: $headers');
    }
    out(' - Input CSV flat headers: ${flatHeaders ? 'yes' : 'no'}');
  }
}
