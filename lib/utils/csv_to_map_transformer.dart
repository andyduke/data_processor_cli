import 'dart:async';
import 'package:data_processor/utils/map_path.dart';

class CSVToMapTransformer extends StreamTransformerBase<List, Map<String, dynamic>> {
  final List<String>? headers;
  final bool flatHeaders;

  CSVToMapTransformer({
    this.headers,
    this.flatHeaders = false,
  });

  @override
  Stream<Map<String, dynamic>> bind(Stream<List> stream) async* {
    final List<dynamic> _headers = headers ?? [];
    await for (var row in stream) {
      if (_headers.isEmpty) {
        _headers.addAll(row);
      } else {
        var item = <String, dynamic>{};
        for (var i = 0; i < row.length; i++) {
          if (flatHeaders) {
            item[_headers[i]] = row[i];
          } else {
            item = MapPath.set(item, _headers[i], row[i]);
          }
        }
        yield item;
      }
    }
  }
}
