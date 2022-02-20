import 'package:data_processor/formatters/yaml_formatter.dart';
import 'package:data_processor/parsers/toml_parser.dart';
import 'package:test/test.dart';

void main() async {
  test('Toml to Yaml', () async {
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

    final yaml = '''title: TOML Example
owner: 
  name: Tom Preston-Werner
  dob: 1979-05-27 07:32:00-08:00
database: 
  server: 192.168.1.1
  ports: 
    - 8000
    - 8001
    - 8002
  connection_max: 5000
  enabled: true
servers: 
  alpha: 
    ip: 10.0.0.1
    dc: eqdc10
  beta: 
    ip: 10.0.0.2
    dc: eqdc10''';

    final parser = TomlParser(data);
    final parsedData = await parser.parse();

    final formatter = YamlFormatter(parsedData, 2);
    final result = await formatter.format();

    // print('$result');

    expect(result, yaml);
  });
}
