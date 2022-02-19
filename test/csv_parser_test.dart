import 'dart:async';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:data_processor/utils/csv_to_map_transformer.dart';
import 'package:test/test.dart';

/*
class CSVStreamTransformer implements StreamTransformer<List, Map<String, dynamic>> {
  final StreamController<Map<String, dynamic>> _controller = StreamController<Map<String, dynamic>>(sync: true);
  final List _headers = [];

  @override
  Stream<Map<String, dynamic>> bind(Stream<List> stream) {
    // Start listening on input stream
    stream.listen((row) {
      if (_headers.isEmpty) {
        _headers.addAll(row);
      } else {
        var item = <String, dynamic>{};
        for (var i = 0; i < row.length; i++) {
          item[_headers[i]] = row[i];
        }
        _controller.add(item);
      }
    });

    // Return an output stream for our listener
    return _controller.stream;
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    return StreamTransformer.castFrom(this);
  }
}
*/

/*
typedef JSONObject = Map<String, dynamic>;

class CSVToMapTransformer extends StreamTransformerBase<List, JSONObject> {
  /// This class should have a `StreamTransformer`
  final StreamTransformer<List<dynamic>, JSONObject> transformer = createTranslator();

  @override
  Stream<JSONObject> bind(Stream<List> stream) => transformer.bind(stream);

  static StreamTransformer<List, JSONObject> createTranslator<List, JSONObject>() =>
      StreamTransformer<List, JSONObject>((Stream inputStream, bool cancelOnError) {
        late StreamController<JSONObject> controller;
        late StreamSubscription subscription;

        final _headers = <dynamic>[];

        controller = StreamController<JSONObject>(
          onListen: () {
            subscription = inputStream.listen(
              (data) {
                if (_headers.isEmpty) {
                  _headers.addAll(data);
                } else {
                  final item = <String, dynamic>{};
                  for (var i = 0; i < data.length; i++) {
                    item[_headers[i]] = data[i];
                  }
                  controller.add(item as JSONObject);
                }
              },
              onDone: controller.close,
              onError: controller.addError,
              cancelOnError: cancelOnError,
            );
          },
          onPause: () => subscription.pause(),
          onResume: () => subscription.resume(),
          onCancel: () => subscription.cancel(),
        );

        /// Finally, return the listen function on the new stream.
        return controller.stream.listen(null);
      });
}
*/

/*
class CSVToMapTransformer extends StreamTransformerBase<List, Map<String, dynamic>> {
  final StreamTransformer<List, Map<String, dynamic>> transformer;

  CSVToMapTransformer() : transformer = createTranslator();

  @override
  Stream<Map<String, dynamic>> bind(Stream<List> stream) => transformer.bind(stream);

  static StreamTransformer<List, Map<String, dynamic>> createTranslator() =>
      StreamTransformer<List, Map<String, dynamic>>((Stream inputStream, bool cancelOnError) {
        late StreamController<Map<String, dynamic>> controller;
        StreamSubscription? subscription;

        final _headers = <dynamic>[];

        controller = StreamController<Map<String, dynamic>>(
          sync: true,
          onListen: () {
            subscription = inputStream.listen(
              (data) {
                if (_headers.isEmpty) {
                  _headers.addAll(data);
                } else {
                  final item = <String, dynamic>{};
                  for (var i = 0; i < data.length; i++) {
                    print('- ${_headers[i]}: ${data[i]}');
                    item[_headers[i]] = data[i];
                  }
                  print('$item');
                  controller.add(item);
                }
              },
              onDone: controller.close,
              onError: controller.addError,
              cancelOnError: cancelOnError,
            );
          },
          onPause: () => subscription?.pause(),
          onResume: () => subscription?.resume(),
          onCancel: () => subscription?.cancel(),
        );

        /// Finally, return the listen function on the new stream.
        return controller.stream.listen(null);
      });
}
*/

void main() {
  test('CSV to List', () async {
    /*
    const conv = ListToCsvConverter(fieldDelimiter: ';', textDelimiter: '"', eol: '\r\n');
    final res = conv.convert([
      ['name', 'perms'],
      ['User 1'],
      ['Admin', 7],
      ['User 2'],
    ]);
    print('$res');
    return;
    */

    final csvData = [
      ['name', 'perms'],
      ['User 1'],
      ['Admin', 7],
      ['User 2'],
    ];
    final data = '''name;perms
User 1
Admin;7
User 2''';
    const conv = CsvToListConverter(fieldDelimiter: ';', textDelimiter: '"', eol: '\n');
    final result = conv.convert(data);

    expect(result, csvData);
  });

  test('Simple', () async {
    final csvData = [
      {
        'name': 'User 1',
      },
      {
        'name': 'Admin',
        'perms': 7,
      },
      {
        'name': 'User 2',
      },
    ];
    final data = '''name;perms
User 1
Admin;7
User 2''';
    const conv = CsvToListConverter(fieldDelimiter: ';', textDelimiter: '"', eol: '\n');
    final csv = conv.convert(data);

    final headers = csv.first;
    final rows = csv.getRange(1, csv.length);
    final result = [];
    for (var row in rows) {
      var item = {};
      for (var i = 0; i < row.length; i++) {
        item[headers[i]] = row[i];
      }
      result.add(item);
    }

    expect(result, csvData);
  });

  test('Simple (stream)', () async {
    final csvData = [
      {
        'name': 'User 1',
      },
      {
        'name': 'Admin',
        'perms': 7,
      },
      {
        'name': 'User 2',
      },
    ];
    final data = '''name;perms
User 1
Admin;7
User 2''';
    // final csvStream = Stream.value(data.codeUnits);
    // const conv = CsvToListConverter(fieldDelimiter: ';', textDelimiter: '"', eol: '\n');
    // final csv = await csvStream.transform(utf8.decoder).transform(conv).toList();
    final csvStream = Stream.value(data);
    const conv = CsvToListConverter(fieldDelimiter: ';', textDelimiter: '"', eol: '\n');
    final csv = await csvStream.transform(conv).toList();

    final headers = csv.first;
    final rows = csv.getRange(1, csv.length);
    final result = [];
    for (var row in rows) {
      var item = {};
      for (var i = 0; i < row.length; i++) {
        item[headers[i]] = row[i];
      }
      result.add(item);
    }

    expect(result, csvData);
  });

  test('Transform stream', () async {
    final csvData = [
      {
        'name': 'User 1',
      },
      {
        'name': 'Admin',
        'perms': 7,
      },
      {
        'name': 'User 2',
      },
    ];
    final data = '''name;perms
User 1
Admin;7
User 2''';
    final csvStream = Stream.value(data.codeUnits);
    const conv = CsvToListConverter(fieldDelimiter: ';', textDelimiter: '"', eol: '\n');
    final testConv = StreamTransformer<List<dynamic>, dynamic>.fromHandlers(
      handleData: (data, sink) {
        print('- $data');
        sink.add(data);
      },
    );
    final csv = await csvStream.transform(utf8.decoder).transform(conv).transform(testConv).toList();

    final headers = csv.first;
    final rows = csv.getRange(1, csv.length);
    final result = [];
    for (var row in rows) {
      var item = {};
      for (var i = 0; i < row.length; i++) {
        item[headers[i]] = row[i];
      }
      result.add(item);
    }

    expect(result, csvData);
  });

  test('CSVToMapTransformer', () async {
    final csvData = [
      {
        'name': 'User 1',
      },
      {
        'name': 'Admin',
        'perms': 7,
      },
      {
        'name': 'User 2',
      },
    ];
    final data = '''name;perms
User 1
Admin;7
User 2''';
    final csvStream = Stream.value(data.codeUnits);
    const conv = CsvToListConverter(fieldDelimiter: ';', textDelimiter: '"', eol: '\n');
    final result = await csvStream.transform(utf8.decoder).transform(conv).transform(CSVToMapTransformer()).toList();

    expect(result, csvData);
  });

  test('CSVToMapTransformer (with headers)', () async {
    final csvData = [
      {
        'name': 'User 1',
      },
      {
        'name': 'Admin',
        'perms': 7,
      },
      {
        'name': 'User 2',
      },
    ];
    final data = '''User 1
Admin;7
User 2''';
    final csvStream = Stream.value(data.codeUnits);
    const conv = CsvToListConverter(fieldDelimiter: ';', textDelimiter: '"', eol: '\n');
    final result = await csvStream
        .transform(utf8.decoder)
        .transform(conv)
        .transform(CSVToMapTransformer(
          headers: ['name', 'perms'],
        ))
        .toList();

    expect(result, csvData);
  });

  test('CSVToMapTransformer (nested objects)', () async {
    final csvData = [
      {
        'name': 'User 1',
      },
      {
        'name': 'Admin',
        'perms': {
          'code': 7,
        },
      },
      {
        'name': 'User 2',
      },
    ];
    final data = '''name;perms.code
User 1
Admin;7
User 2''';
    // final csvStream = Stream.value(data.codeUnits);
    // const conv = CsvToListConverter(fieldDelimiter: ';', textDelimiter: '"', eol: '\n');
    // final result = await csvStream.transform(utf8.decoder).transform(conv).transform(CSVToMapTransformer()).toList();

    const conv = CsvToListConverter(fieldDelimiter: ';', textDelimiter: '"', eol: '\n');
    final result = await Stream.value(data).transform(conv).transform(CSVToMapTransformer()).toList();

    expect(result, csvData);
  });

  test('CSVToMapTransformer (flat headers)', () async {
    final csvData = [
      {
        'name': 'User 1',
      },
      {
        'name': 'Admin',
        'perms.code': 7,
      },
      {
        'name': 'User 2',
      },
    ];
    final data = '''name;perms.code
User 1
Admin;7
User 2''';

    const conv = CsvToListConverter(fieldDelimiter: ';', textDelimiter: '"', eol: '\n');
    final result = await Stream.value(data).transform(conv).transform(CSVToMapTransformer(flatHeaders: true)).toList();

    expect(result, csvData);
  });
}
