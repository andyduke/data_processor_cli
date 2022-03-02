import 'package:test/test.dart';
import 'package:yaml/yaml.dart';
import 'package:data_processor/utils/yaml_utils.dart';

void main() {
  test('YamlMap to Map', () {
    var yaml = loadYaml('''map:
- id: 1
  name: One
- id: 2
  name: Two
''');

    if (yaml is YamlNode) {
      yaml = YamlNodeConverter(yaml).toDynamic();
    }

    expect(yaml, isA<Map<String, dynamic>>());
  });

  test('YamlMap to List', () {
    var yaml = loadYaml('''- One
- Two
''');

    if (yaml is YamlNode) {
      yaml = YamlNodeConverter(yaml).toDynamic();
    }

    expect(yaml, isA<List>());
  });

  test('YamlMap to Scalar', () {
    var yaml = loadYaml('Scalar value');

    if (yaml is YamlNode) {
      yaml = YamlNodeConverter(yaml).toDynamic();
    }

    expect(yaml, isA<String>());
  });
}
