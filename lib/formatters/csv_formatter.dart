import 'package:data_processor/formatters/formatter.dart';

class CSVFormatter extends DataFormatter {
  CSVFormatter(data, int indent) : super(data, indent);

  @override
  Future<String> format() {
    throw UnimplementedError();
  }
}
