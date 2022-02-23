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

// {% with var as "path" %}...{% endwith %}
class WithPathBlock extends liquid.Block {
  String name;
  String? expression;

  WithPathBlock(this.name, this.expression, children) : super(children);

  @override
  Stream<String> render(liquid.RenderContext context) {
    final data = (expression != null)
        ? <String, dynamic>{
            name: jmespath.search(expression!, context.variables),
          }
        : <String, dynamic>{};

    var innerContext = context.push(data);
    return super.render(innerContext);
  }

  static final liquid.SimpleBlockFactory factory = factoryBuilder;

  static liquid.Block factoryBuilder(tokens, children) {
    // if (tokens.length < 3) return WithPathBlock('', null, []);
    if (tokens.length < 3) {
      throw Exception('Invalid "with" block');
    }

    // Get variable name
    final name = tokens.first.value;

    // Combine path
    String path = tokens.skip(2).map((t) => t.value).join('');

    // Trim surrounding quotes
    if (path.substring(0, 1) == '"') {
      path = path.substring(1, path.length - 1);
    }

    return WithPathBlock(name, path, children);
  }
}

dynamic JmesQueryFilter(dynamic input, List args) {
  if (args.isEmpty) return input;
  final path = '${args.first}';
  final data = jmespath.search(path, input);
  return data;
}

class TemplateFormatter extends DataFormatter {
  final String template;

  TemplateFormatter(data, this.template) : super(data);

  @override
  Future<String> format() async {
    final context = liquid.Context.create();
    context.tags['by_path'] = liquid.BlockParser.simple(JmesPathBlock.factory);
    context.tags['with'] = liquid.BlockParser.simple(WithPathBlock.factory);
    context.filters['query'] = JmesQueryFilter;

    if (data is Map) {
      context.variables.addAll(data);
    }
    final tplSource = liquid.Source.fromString(template);
    final templater = liquid.Template.parse(context, tplSource);
    final result = await templater.render(context);
    return result;
  }
}
