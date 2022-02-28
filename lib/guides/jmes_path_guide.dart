import 'package:data_processor/guides/guide.dart';

class JMESPathGuide extends Guide {
  @override
  final String title = 'JMESPath Guide';

  @override
  final String text = r'''
# JMESPath Guide

See [](https://jmespath.org/tutorial.html) for more details.
''';

  JMESPathGuide(
    GuideOutput out, {
    GuideIntro? intro,
  }) : super(
          out,
          intro: intro,
        );
}
