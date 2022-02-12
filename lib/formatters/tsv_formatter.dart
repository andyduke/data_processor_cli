import 'package:data_processor/formatters/formatter.dart';

class TSVFormatter extends DataFormatter {
  TSVFormatter(data, int indent) : super(data, indent);

  @override
  Future<String> format() {
    throw UnimplementedError();
  }
}
