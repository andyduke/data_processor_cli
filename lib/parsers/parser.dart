abstract class Parser {
  final String data;

  Parser(this.data);

  Future<dynamic> parse();
}
