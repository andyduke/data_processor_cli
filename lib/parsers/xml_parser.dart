import 'package:data_processor/parsers/parser.dart';
import 'package:xml_map_converter/xml_map_converter.dart';

class XMLParser extends Parser {
  final String? attrPrefix;
  final String? textNode;
  final String? cdataNode;

  XMLParser(
    String data, {
    this.attrPrefix,
    this.textNode,
    this.cdataNode,
  }) : super(data);

  @override
  Future<dynamic> parse() async {
    final converter = Xml2Map(
      data,
      attrPrefix: attrPrefix ?? defaultAttrPrefix,
      textNode: textNode ?? defaultTextNode,
      cdataNode: cdataNode ?? defaultCdataNode,
    );
    final result = await converter.transform();
    return result;
  }
}
