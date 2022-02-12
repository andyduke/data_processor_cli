import 'package:data_processor/formatters/formatter.dart';
import 'package:liquid_engine/liquid_engine.dart' as liquid;

class TemplateFormatter extends DataFormatter {
  final String template;

  TemplateFormatter(data, this.template) : super(data);

  @override
  Future<String> format() async {
    final context = liquid.Context.create();
    if (data is Map) {
      context.variables.addAll(data);
    }
    final tplSource = liquid.Source.fromString(template);
    final templater = liquid.Template.parse(context, tplSource);
    final result = await templater.render(context);
    return result;
  }
}
