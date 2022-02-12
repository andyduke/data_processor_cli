import 'package:pretty_json/pretty_json.dart' as json;
import 'package:data_processor/formatters/formatter.dart';

class JSONFormatter extends DataFormatter {
  JSONFormatter(data, int indent) : super(data, indent);

  @override
  Future<String> format() async {
    final result = json.prettyJson(data, indent: indent);
    return result;
  }
}
