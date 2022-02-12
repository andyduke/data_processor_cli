import 'package:data_processor/parsers/parser.dart';

class CSVParser extends Parser {
  CSVParser(String data) : super(data);

  @override
  Future<dynamic> parse() async {
    throw UnimplementedError();
  }
}
