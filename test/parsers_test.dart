import 'dart:convert';
import 'package:data_processor/parsers/csv_parser.dart';
import 'package:data_processor/parsers/json_parser.dart';
import 'package:data_processor/parsers/toml_parser.dart';
import 'package:data_processor/parsers/xml_parser.dart';
import 'package:data_processor/parsers/yaml_parser.dart';
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
    final data = '''# This is a TOML document.

title = "TOML Example"

[owner]
name = "Tom Preston-Werner"
dob = 1979-05-27T07:32:00-08:00 # First class dates

[database]
server = "192.168.1.1"
ports = [ 8000, 8001, 8002 ]
connection_max = 5000
enabled = true

[servers]

  # Indentation (tabs and/or spaces) is allowed but not required
  [servers.alpha]
  ip = "10.0.0.1"
  dc = "eqdc10"

  [servers.beta]
  ip = "10.0.0.2"
  dc = "eqdc10"''';
    final parser = TomlParser(data);
    final result = await parser.parse();

    // print('$result');

    expect(result, tomlData);
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
    <item type="text">
      Text
    </item>
    <data name="test">
      <![CDATA[
        cdata
      ]]>
    </data>
    <item type="sample">
      Item 2
    </item>
  </items>
</root>''';

    final parser = XMLParser(data);
    final result = await parser.parse();

    // print('$result');

    expect(result, xmlData);
  });
}
