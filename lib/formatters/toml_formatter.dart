import 'package:data_processor/formatters/formatter.dart';
import 'package:toml/toml.dart';

class TomlFormatter extends DataFormatter {
  static const String defaultRoot = 'toml';

  final String? root;

  TomlFormatter(
    data,
    int indent, {
    this.root,
  }) : super(data, indent);

  @override
  Future<String> format() async {
    if (data != null) {
      final tomlData = (data is Map) ? data : {root ?? defaultRoot: data};
      final result = TomlDocument.fromMap(tomlData).toString();
      return result;
    } else {
      return '';
    }
  }
}
