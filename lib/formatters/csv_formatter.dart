import 'package:csv/csv.dart';
import 'package:data_processor/formatters/formatter.dart';
import 'package:data_processor/utils/map_flatten.dart';

class CSVFormatter extends DataFormatter {
  final String columnSeparator;
  final String rowSeparator;
  final String textQuote;

  CSVFormatter(
    data,
    int indent, {
    this.columnSeparator = defaultFieldDelimiter,
    this.rowSeparator = defaultEol,
    this.textQuote = defaultTextDelimiter,
  }) : super(data, indent);

  @override
  Future<String> format() async {
    final converter = ListToCsvConverter(
      fieldDelimiter: columnSeparator,
      eol: rowSeparator,
      textDelimiter: textQuote,
    );

    final listData = (data is! List) ? [data] : data;
    final flattenData = _flatten(listData);
    final csvData = _transform(flattenData);
    final result = converter.convert(
      csvData,
      fieldDelimiter: columnSeparator,
      eol: rowSeparator,
      textDelimiter: textQuote,
    );

    return result;
  }

  dynamic _flatten(dynamic data) {
    if (data is List) {
      return data.map((e) => _flatten(e)).toList(growable: false);
    } else if (data is Map<String, dynamic>) {
      return flatten(data);
    } else {
      return data;
    }
  }

  List<List> _transform(List data) {
    if (data.isEmpty) return [];

    final headers = <String>[];
    for (var row in data) {
      if (row is! Map<String, dynamic>) {
        throw Exception('Data is not map.');
      }

      final rowHeaders = row.keys.toList(growable: false);
      for (var column in rowHeaders) {
        if (!headers.contains(column)) {
          headers.add(column);
        }
      }
    }

    final rows = [];
    for (var row in data) {
      var item = [];
      for (var column in headers) {
        if (row.containsKey(column)) {
          item.add(row[column]);
        } else {
          item.add(null);
        }
      }

      // Remove trailing nulls
      item = item.reversed.skipWhile((value) => value == null).toList().reversed.toList();

      rows.add(item);
    }

    return [
      headers,
      ...rows,
    ];
  }
}
