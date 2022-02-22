import 'package:args/args.dart';
import 'package:data_processor/options/summary_output.dart';
import 'package:xml_map_converter/xml_map_converter.dart' as xml2map;

class InputXMLOptions implements SummaryOutput {
  final String? attrPrefix;
  final String? textNode;
  final String? cdataNode;

  const InputXMLOptions({
    this.attrPrefix,
    this.textNode,
    this.cdataNode,
  });

  InputXMLOptions.fromArguments(ArgResults arguments)
      : attrPrefix = arguments['input-xml-attr-prefix'],
        textNode = arguments['input-xml-text-node'],
        cdataNode = arguments['input-xml-cdata-node'];

  static void cliOptions(ArgParser parser) {
    parser.addOption(
      'input-xml-attr-prefix',
      help: 'Prefix denoting "key-attribute".',
      valueHelp: 'prefix',
      defaultsTo: xml2map.defaultAttrPrefix,
    );

    parser.addOption(
      'input-xml-text-node',
      help: 'The name of the key for the content of the xml node.',
      valueHelp: 'name',
      defaultsTo: xml2map.defaultTextNode,
    );

    parser.addOption(
      'input-xml-cdata-node',
      help: 'The name of the key for the content of the CDATA xml node.',
      valueHelp: 'name',
      defaultsTo: xml2map.defaultCdataNode,
    );
  }

  @override
  void displaySummary(void Function(String message) out) {
    if (attrPrefix != null) {
      out(' - Input XML attribute prefix: $attrPrefix');
    }
    if (textNode != null) {
      out(' - Input XML text node name: $textNode');
    }
    if (cdataNode != null) {
      out(' - Input XML CDATA node name: $cdataNode');
    }
  }
}
