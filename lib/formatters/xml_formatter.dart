import 'package:data_processor/consts.dart';
import 'package:data_processor/formatters/formatter.dart';
import 'package:xml_map_converter/xml_map_converter.dart';

class XMLFormatter extends DataFormatter {
  static const String defaultRootNode = 'root';

  final String? rootNode;
  final String? eol;
  final String? declaration;
  final String? attrPrefix;
  final String? textNode;
  final String? cdataNode;

  XMLFormatter(
    data,
    int indent, {
    this.rootNode = defaultRootNode,
    this.eol,
    this.declaration,
    this.attrPrefix,
    this.textNode,
    this.cdataNode,
  }) : super(data, indent);

  @override
  Future<String> format() async {
    final xmlData = (data is Map) ? data : {rootNode ?? defaultRootNode: data};

    final converter = Map2Xml(
      xmlData,
      eol: eol ?? defaultEol,
      xmlPrefix: declaration ?? Map2Xml.defaultXmlPrefix,
      attrPrefix: attrPrefix ?? defaultAttrPrefix,
      textNode: textNode ?? defaultTextNode,
      cdataNode: cdataNode ?? defaultCdataNode,
    );
    final result = converter.transform();
    return result;
  }
}
