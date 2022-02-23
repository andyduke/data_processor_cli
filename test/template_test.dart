import 'package:data_processor/formatters/template_formatter.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('JmesPath', () async {
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
}
