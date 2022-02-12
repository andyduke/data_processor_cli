abstract class DataFormatter {
  static const int defaultIndent = 2;

  final dynamic data;
  final int indent;

  DataFormatter(this.data, [this.indent = defaultIndent]);

  Future<String> format();
}
