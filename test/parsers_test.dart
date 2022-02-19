import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:data_processor/parsers/csv_parser.dart';
import 'package:data_processor/parsers/json_parser.dart';
import 'package:data_processor/parsers/yaml_parser.dart';
import 'package:test/test.dart';

void main() {
  test('JSON', () async {
    final jsonData = {
      'users': [
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
      ],
    };
    final data = json.encode(jsonData);
    final parser = JSONParser(data);
    final result = await parser.parse();

    expect(result, jsonData);
  });

  test('Yaml', () async {
    final yamlData = {
      'users': [
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
      ],
    };
    final data = '''users:
  - name: User 1
  - name: Admin
    perms: 7
  - name: User 2''';
    final parser = YamlParser(data);
    final result = await parser.parse();

    expect(result, yamlData);
  });

  test('CSV', () async {
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

    // final csvData = [
    //   ['name', 'perms'],
    //   ['User 1'],
    //   ['Admin', 7],
    //   ['User 2'],
    // ];
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
    final parser = CSVParser(
      data,
      columnSeparator: ';',
      rowSeparator: '\n',
    );
    final result = await parser.parse();

    expect(result, csvData);
  });
}
