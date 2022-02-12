import 'dart:convert';

import 'package:data_processor/data_processor.dart';
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
    final processor = DataProcessor(
      data: data,
      inputFormat: 'json',
    );
    final result = await processor.process();

    expect(result, data);
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
      query: 'users[*].name',
      inputFormat: 'json',
    );
    final result = await processor.process();

    final expectData = json.encode(jsonData['users']!.map((e) => e['name']).toList());

    expect(result, expectData);
  });
}
