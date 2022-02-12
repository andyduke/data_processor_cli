import 'package:data_processor/formatters/formatter.dart';

class XMLFormatter extends DataFormatter {
  XMLFormatter(data, int indent) : super(data, indent);

  @override
  Future<String> format() {
    throw UnimplementedError();
  }
}
