import 'package:data_processor/formatters/formatter.dart';
import 'package:liquid_engine/liquid_engine.dart' as liquid;
import 'package:jmespath/jmespath.dart' as jmespath;

class JmesPathBlock extends liquid.Block {
  String? expression;

  JmesPathBlock(this.expression) : super([]);

  @override
  Stream<String> render(liquid.RenderContext context) async* {
    if (expression == null) {
      yield '';
    } else {
      final result = jmespath.search(expression!, context.variables);
      yield '$result';
    }
  }

  static final liquid.SimpleBlockFactory factory = factoryBuilder;

  static liquid.Block factoryBuilder(tokens, children) {
    if (tokens.isEmpty) return JmesPathBlock(null);

    // Combine expression
    String path = tokens.map((t) => t.value).join('');

    // Trim surrounding quotes
    if (path.substring(0, 1) == '"') {
      path = path.substring(1, path.length - 1);
    }

    return JmesPathBlock(path);
  }
}

class TemplateFormatter extends DataFormatter {
  final String template;

  TemplateFormatter(data, this.template) : super(data);

  @override
  Future<String> format() async {
    final context = liquid.Context.create();
    context.tags['by_path'] = liquid.BlockParser.simple(JmesPathBlock.factory);

    if (data is Map) {
      context.variables.addAll(data);
    }
    final tplSource = liquid.Source.fromString(template);
    final templater = liquid.Template.parse(context, tplSource);
    final result = await templater.render(context);
    return result;
  }
}
