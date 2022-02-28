import 'package:data_processor/guides/guide.dart';

class TemplateGuide extends Guide {
  @override
  final String title = 'Template Guide';

  @override
  final String text = r'''
# Template Guide

See [](https://docs.djangoproject.com/en/4.0/ref/templates/language/) for more details.
''';

  TemplateGuide(
    GuideOutput out, {
    GuideIntro? intro,
  }) : super(
          out,
          intro: intro,
        );
}
