import 'package:data_processor/markdown.dart';

typedef GuideOutput = void Function(String message);
typedef GuideIntro = String Function();

abstract class Guide {
  abstract final String text;

  final GuideOutput out;
  final GuideIntro? intro;

  Guide(
    this.out, {
    this.intro,
  });

  void display(String? format) {
    late final String result;
    if (format != 'md') {
      result = renderMarkdown(text);
    } else {
      result = text;
    }

    if (intro != null) out(intro!.call());
    out(result);
  }
}
