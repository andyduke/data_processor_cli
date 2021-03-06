import 'package:data_processor/guides/guide.dart';

class JMESPathGuide extends Guide {
  @override
  final String title = 'JMESPath Guide';

  @override
  final String text = r'''
# JMESPath Guide

JMESPath (pronounced "james path") allows you to declaratively specify how to extract elements from a JSON document.

For example, given this document:
```json
{"foo": {"bar": "baz"}}
```
The jmespath expression `foo.bar` will return "baz".

## JMESPath also supports:

Referencing elements in a list. Given the data:
```json
{"foo": {"bar": ["one", "two"]}}
```

The expression: `foo.bar[0]` will return "one". You can also reference all the items in a list using the `*` syntax:
```json
{"foo": {"bar": [{"name": "one"}, {"name": "two"}]}}
```

The expression: `foo.bar[*].name` will return ["one", "two"]. Negative indexing is also supported (-1 refers to the last element in the list). Given the data above, the expression `foo.bar[-1].name` will return "two".

The `*` can also be used for hash types:
```json
{"foo": {"bar": {"name": "one"}, "baz": {"name": "two"}}}
```

The expression: `foo.*.name` will return ["one", "two"].

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
