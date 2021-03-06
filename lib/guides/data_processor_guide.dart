import 'package:data_processor/guides/guide.dart';

class DataProcessorGuide extends Guide {
  @override
  final String title = 'Data Processor Guide';

  @override
  final String text = r'''
# Data Processor Guide

The Data Processor is a tool for converting structured data from one format to another, with the ability to select a portion of a piece of data to convert, or use a template to compose the result.

Supported input and output formats: JSON, Yaml, XML, CSV, TOML.

The output can be generated using a template language similar to [django/liquid template language](https://docs.djangoproject.com/en/4.0/ref/templates/language/).

It is possible to select only a portion of the input data using the [JMESPath](https://jmespath.org/) query language.

## Usage

```
dp "<query>" [<filename>] [options] > output_file
```
or
```
type <filename> | dp "<query>" [options] > output_file
```

The *query* is a JMESPath.

You can find out all the options using the **--help** parameter.

### JMESPath

In the Data Processor, the JMESPath must be passed as the first parameter to extract a chunk from the input data.
If you want to use the entire input data (for example, to convert from one format to another), you must pass a dot instead of JMESPath.

```shell
dp "." users.json -o yaml > users.yaml
```

### Input data

The Data Processor tries to determine the input data type from the input file name extension, but you can force the data type (using the **-i** option) if the file name has no extension or the extension is non-standard.
You can also pass input using a pipe, but you must specify the type of the input.

## Getting a piece of data as JSON from XML

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

## Creating a text file of any format based on structured data

It is possible to create files in formats not supported by the Data Processor using the template language.

For example, from the data of the `orders.yaml` file:
```yaml
account:
  name: Classic Cars
  customerName: John Doe
  orders:
  - orderId: 1
    productId: C6
    productName: Corvette C6
    price: 45849
  - orderId: 2
    productId: M4
    productName: Morgan Plus 4
    price: 69995
```

...using the template file `orders.template`:
```
Account "{{ account.name }}"
Customer "{{ account.customerName }}"

Orders
======
{% for order in account.orders -%}
Order ID #{{ order.orderId }}
Product #{{ order.productId }}, {{ order.productName }}
  Price {{ order.price }}

{% endfor -%}

Total {% by_path "sum(account.orders[*].price)" %}
```

...with the command:
```
dp "." orders.yaml -o template -t orders.template
```

...generate the following file: 
```
Account "Classic Cars"
Customer "John Doe"

Orders
======
Order ID #1
Product #C6, Corvette C6
  Price 45849

Order ID #2
Product #M4, Morgan Plus 4
  Price 69995

Total 115844.0
```

You can learn more about the template language using the **--template-guide** option.
''';

  DataProcessorGuide(
    GuideOutput out, {
    GuideIntro? intro,
  }) : super(
          out,
          intro: intro,
        );
}
