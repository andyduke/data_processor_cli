import 'package:data_processor/guides/guide.dart';

class DataProcessorGuide extends Guide {
  @override
  final String text = r'''
# Data Processor Guide

The Data Processor is a tool for converting structured data from one format to another, with the ability to select a portion of a piece of data to convert, or use a template to compose the result.

Supported input and output formats: JSON, Yaml, XML, CSV, TOML.

The output can be generated using a template language similar to [django/liquid template language](https://docs.djangoproject.com/en/4.0/ref/templates/language/).

It is possible to select only a portion of the input data using the [JMESPath](https://jmespath.org/) query language.

## Usage example

For example, you need to select certain users with the "user" role from the XML data and display their names in the JSON list format.

There is a `sample.xml` file with data:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<users>
  <user id="1">
    <name>John Doe</name>
    <role>user</role>
  </user>
  <user id="2">
    <name>Richard Roe</name>
    <role>administrator</role>
  </user>
  <user id="3">
    <name>Jane Doe</name>
    <role>user</role>
  </user>
</users>
```

...command
```
dp "users.user[?role=='user'].name" sample.xml -o json
```

...will output the following:
```json
[
  "John Doe",
  "Jane Doe"
]
```

## JSON to XML conversion with mapping

For example, you need to convert a JSON structure to XML, but transform some JSON properties (id) into XML attributes, and change the names of some properties (users to persons and user to person) - this can be done using a query with multiselect hash and a pipe expression.

There is a `sample.json` file with data:
```json
{
  "users": {
    "user": [
      {
        "id": 1,
        "name": "John Doe",
        "role": "user"
      },
      {
        "id": 2,
        "name": "Richard Roe",
        "role": "admin"
      }
    ]
  }
}
```

...command
```
dp "users.user[*].{\"@id\": id, name: name} | {persons: {person: @}}" sample.json -o xml
```

...will output the following:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<persons>
  <person id="1">
    <name>John Doe</name>
  </person>
  <person id="2">
    <name>Richard Roe</name>
  </person>
</persons>
```

''';

  DataProcessorGuide(
    GuideOutput out, {
    GuideIntro? intro,
  }) : super(
          out,
          intro: intro,
        );
}
