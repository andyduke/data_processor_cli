import 'package:args/args.dart';
import 'package:data_processor/formatters/xml_formatter.dart';
import 'package:data_processor/options/summary_output.dart';
import 'package:xml_map_converter/xml_map_converter.dart' as xml2map;

class OutputXMLOptions implements SummaryOutput {
  final String? declaration;
  final String? rootNode;
  final String? attrPrefix;
  final String? textNode;
  final String? cdataNode;

  const OutputXMLOptions({
    this.declaration,
    this.rootNode,
    this.attrPrefix,
    this.textNode,
    this.cdataNode,
  });

  OutputXMLOptions.fromArguments(ArgResults arguments)
      : declaration = arguments['output-xml-declaration'],
        rootNode = arguments['output-xml-root-node'],
        attrPrefix = arguments['output-xml-attr-prefix'],
        textNode = arguments['output-xml-text-node'],
        cdataNode = arguments['output-xml-cdata-node'];

  static void cliOptions(ArgParser parser) {
    parser.addOption(
      'output-xml-declaration',
      help:
          'The XML declaration is a processing instruction that identifies the document as being XML. Set to the empty string to omit the declaration.',
      valueHelp: 'declaration',
      defaultsTo: xml2map.Map2Xml.defaultXmlPrefix,
    );

    parser.addOption(
      'output-xml-root-node',
      help: 'The name of the root tag if the data is not a dictionary.',
      valueHelp: 'node',
      defaultsTo: XMLFormatter.defaultRootNode,
    );

    parser.addOption(
      'output-xml-attr-prefix',
      help: 'Prefix denoting "key-attribute".',
      valueHelp: 'prefix',
      defaultsTo: xml2map.defaultAttrPrefix,
    );

    parser.addOption(
      'output-xml-text-node',
      help: 'The name of the key for the content of the xml node.',
      valueHelp: 'name',
      defaultsTo: xml2map.defaultTextNode,
    );

    parser.addOption(
      'output-xml-cdata-node',
      help: 'The name of the key for the content of the CDATA xml node.',
      valueHelp: 'name',
      defaultsTo: xml2map.defaultCdataNode,
    );
  }

  @override
  void displaySummary(void Function(String message) out) {
    if (declaration != null) {
      out(' - Output XML declaration: $declaration');
    }
    if (rootNode != null) {
      out(' - Output XML root node name: $rootNode');
    }
    if (attrPrefix != null) {
      out(' - Output XML attribute prefix: $attrPrefix');
    }
    if (textNode != null) {
      out(' - Output XML text node name: $textNode');
    }
    if (cdataNode != null) {
      out(' - Output XML CDATA node name: $cdataNode');
    }
  }
}
