import 'package:csv/csv.dart';
import 'package:data_processor/formatters/csv_formatter.dart';

class TSVFormatter extends CSVFormatter {
  TSVFormatter(
    data,
    int indent, {
    String rowSeparator = defaultEol,
    String textQuote = defaultTextDelimiter,
  }) : super(
          data,
          indent,
          columnSeparator: '\t',
          rowSeparator: rowSeparator,
          textQuote: textQuote,
        );
}
