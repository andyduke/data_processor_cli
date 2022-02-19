extension StringEscape on String {
  String escape() {
    return replaceAll('\t', '<tab>').replaceAll('\n', '<lf>').replaceAll('\r', '<cr>');
  }

  String unescape() {
    return replaceAll(RegExp('<tab>', caseSensitive: false), '\t')
        .replaceAll(RegExp('<lf>', caseSensitive: false), '\n')
        .replaceAll(RegExp('<cr>', caseSensitive: false), '\r');
  }
}
