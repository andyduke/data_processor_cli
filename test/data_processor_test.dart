import 'dart:convert';

import 'package:data_processor/data_processor.dart';
import 'package:data_processor/options/data_processor_options.dart';
import 'package:pretty_json/pretty_json.dart';
import 'package:test/test.dart';

void main() {
  test('Passthrough', () async {
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
    final expectedData =
        '''{
  "users": [
    {
      "name": "User 1"
    },
    {
      "name": "Admin",
      "perms": 7
    },
    {
      "name": "User 2"
    }
  ]
}''';

    final processor = DataProcessor(
      data: data,
      options: DataProcessorOptions(
        inputFormat: 'json',
      ),
    );
    final result = await processor.process();

    expect(result, expectedData);
  });

  test('Simple query', () async {
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
    final processor = DataProcessor(
      data: data,
      options: DataProcessorOptions(
        query: 'users[*].name',
        inputFormat: 'json',
      ),
    );
    final result = await processor.process();

    final expectData = prettyJson(jsonData['users']!.map((e) => e['name']).toList());

    expect(result, expectData);
  });
}
