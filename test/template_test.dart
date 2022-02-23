import 'package:data_processor/formatters/template_formatter.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('by_path', () async {
    final data = {
      "foo": [
        {"age": 20},
        {"age": 25},
        {"age": 30},
        {"age": 35},
        {"age": 40},
      ],
    };
    final template = '''
Value by jmespath: {% by_path "foo[?age > `30`]" %}!
''';

    final t = TemplateFormatter(data, template);
    final result = await t.format();

    // print('$result');

    final expectedData = 'Value by jmespath: [{age: 35}, {age: 40}]';
    expect(result, expectedData);
  });

  test('with', () async {
    final data = {
      "settings": {
        "network": {"hostname": "server1"},
        "shares": [
          {"name": "Video", "path": "/video"},
          {
            "name": "Files",
            "path": "/files",
            "priveleges": {"user": "user1", "perms": 7}
          },
          {"name": "Logs", "path": "/logs"}
        ]
      }
    };
    final template = '''
Priveleged shares:
{% with entries as "settings.shares[?priveleges]" %}
{%- for entry in entries -%}
- {{ entry.name }}
  {{ entry.path }}
{%- endfor -%}
{% endwith -%}
''';

    final t = TemplateFormatter(data, template);
    final result = await t.format();

    // print('$result');

    final expectedData = '''Priveleged shares:
- Files
  /files''';
    expect(result, expectedData);
  });

  test('query filter', () async {
    final data = {
      "settings": {
        "network": {"hostname": "server1"},
        "shares": [
          {"name": "Video", "path": "/video"},
          {
            "name": "Files",
            "path": "/files",
            "priveleges": {"user": "user1", "perms": 7}
          },
          {"name": "Logs", "path": "/logs"}
        ]
      }
    };
    final template = '''
Priveleged shares:
{% for entry in settings | query: "shares[?priveleges]" -%}
- {{ entry.name }}
  {{ entry.path }}
{%- endfor -%}
''';

    final t = TemplateFormatter(data, template);
    final result = await t.format();

    // print('$result');

    final expectedData = '''Priveleged shares:
- Files
  /files''';
    expect(result, expectedData);
  });
}
