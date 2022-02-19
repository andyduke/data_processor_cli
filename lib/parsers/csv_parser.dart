import 'package:csv/csv.dart';
import 'package:data_processor/parsers/parser.dart';
import 'package:data_processor/utils/csv_to_map_transformer.dart';

class CSVParser extends Parser {
  final List<String>? headers;
  final bool flatHeaders;
  final String columnSeparator;
  final String rowSeparator;
  final String textQuote;

  CSVParser(
    String data, {
    this.headers,
    this.flatHeaders = false,
    this.columnSeparator = defaultFieldDelimiter,
    this.rowSeparator = defaultEol,
    this.textQuote = defaultTextDelimiter,
  }) : super(data);

  @override
  Future<dynamic> parse() async {
    final converter = CsvToListConverter(
      fieldDelimiter: columnSeparator,
      eol: rowSeparator,
      textDelimiter: textQuote,
    );
    final result = await Stream.value(data)
        .transform(converter)
        .transform(CSVToMapTransformer(
          headers: headers,
          flatHeaders: flatHeaders,
        ))
        .toList();
    return result;
  }
}
