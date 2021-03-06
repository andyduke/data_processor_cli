import 'package:data_processor/formatters/csv_formatter.dart';
import 'package:data_processor/formatters/json_formatter.dart';
import 'package:data_processor/formatters/toml_formatter.dart';
import 'package:data_processor/formatters/xml_formatter.dart';
import 'package:data_processor/formatters/yaml_formatter.dart';
import 'package:test/test.dart';
import 'package:toml/toml.dart';

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

  test('Toml', () async {
    final tomlData = {
      'title': 'TOML Example',
      'owner': {
        'name': 'Tom Preston-Werner',
        'dob': TomlOffsetDateTime.parse('1979-05-27 07:32:00-08:00'),
      },
      'database': {
        'server': '192.168.1.1',
        'ports': [8000, 8001, 8002],
        'connection_max': 5000,
        'enabled': true
      },
      'servers': {
        'alpha': {'ip': '10.0.0.1', 'dc': 'eqdc10'},
        'beta': {'ip': '10.0.0.2', 'dc': 'eqdc10'}
      }
    };
    final data = '''title = 'TOML Example'

[owner]
name = 'Tom Preston-Werner'
dob = 1979-05-27 07:32:00-08:00

[database]
server = '192.168.1.1'
ports = [8000, 8001, 8002]
connection_max = 5000
enabled = true

[servers.alpha]
ip = '10.0.0.1'
dc = 'eqdc10'

[servers.beta]
ip = '10.0.0.2'
dc = 'eqdc10'
''';
    final formatter = TomlFormatter(tomlData, 2);
    final result = await formatter.format();

    expect(result, data);
  });

  test('XML', () async {
    final xmlData = {
      'root': {
        'items': {
          'text': 'Plain text',
          'letter': ['A', 'B'],
          'empty': {},
          'group': {
            'item': [
              {
                '@name': 'caption',
                '#text': 'Caption 1',
              },
              {
                '@name': 'url',
                '#text': 'https://www.google.com',
              },
            ],
          },
          'item': [
            {
              '@type': 'text',
              '#text': 'Text',
            },
            {
              '@type': 'sample',
              '#text': 'Item 2',
            },
          ],
          'data': {
            '@name': 'test',
            '#cdata': '''

        cdata
      ''',
          },
        },
      },
    };

    final data = '''<?xml version="1.0" encoding="UTF-8"?>
<root>
  <items>
    <text>Plain text</text>
    <letter>A</letter>
    <letter>B</letter>
    <empty/>
    <group>
      <item name="caption">Caption 1</item>
      <item name="url">https://www.google.com</item>
    </group>
    <item type="text">Text</item>
    <item type="sample">Item 2</item>
    <data name="test">
      <![CDATA[
        cdata
      ]]>
    </data>
  </items>
</root>''';

    final formatter = XMLFormatter(xmlData, 2, eol: '\n');
    final result = await formatter.format();

    expect(result, data);
  });
}
