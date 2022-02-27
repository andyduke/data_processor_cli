import 'package:data_processor/guides/guide.dart';

class TemplateGuide extends Guide {
  @override
  final String text = r'''
# Template Guide

todo...
''';

  TemplateGuide(
    GuideOutput out, {
    GuideIntro? intro,
  }) : super(
          out,
          intro: intro,
        );
}
