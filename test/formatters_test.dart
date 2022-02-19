import 'package:data_processor/formatters/csv_formatter.dart';
import 'package:data_processor/formatters/json_formatter.dart';
import 'package:data_processor/formatters/yaml_formatter.dart';
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
    final data = r'''{
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
    final formatter = JSONFormatter(jsonData, 2);
    final result = await formatter.format();

    expect(result, data);
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
    final formatter = YamlFormatter(yamlData, 2);
    final result = await formatter.format();

    expect(result, data);
  });

  test('CSV', () async {
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
    final formatter = CSVFormatter(
      csvData,
      2,
      columnSeparator: ';',
      rowSeparator: '\n',
    );
    final result = await formatter.format();

    expect(result, data);
  });
}
