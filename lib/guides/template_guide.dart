import 'package:data_processor/guides/guide.dart';

class TemplateGuide extends Guide {
  @override
  final String title = 'Template Guide';

  @override
  final String text = r'''
# Template Guide

The Data Processor supports file generation using a templating language similar to Liquid's or Django's templating language.

A Data Processor template is a text document marked-up using the template language. Some constructs are recognized and interpreted by the template engine. The main ones are variables and tags.

A template is rendered with a input data. Rendering replaces variables with their values, which are looked up in the context, and executes tags. Everything else is output as is.

The syntax of the Django template language involves three constructs.

## Variables

A variable outputs a value from the input data, which is a dict-like object mapping keys to values.

Variables are surrounded by {{ and }} like this:
```
My first name is {{ first_name }}. My last name is {{ last_name }}.
```

With a context of `{'first_name': 'John', 'last_name': 'Doe'}`, this template renders to:
```
My first name is John. My last name is Doe.
```

Dictionary lookup, attribute lookup and list-index lookups are implemented with a dot notation:
```
{{ my_dict.key }}
{{ my_object.attribute }}
{{ my_list.0 }}
```

## Tags

Tags provide arbitrary logic in the rendering process.

This definition is deliberately vague. For example, a tag can output content, serve as a control structure e.g. an "if" statement or a "for" loop, or even enable access to other template tags.

Tags are surrounded by {% and %} like this:
```
{% ifchanged %}
```

Most tags accept arguments:
```
{% cycle 'odd' 'even' %}
```

Some tags require beginning and ending tags:
```
{% if user.roles %}roles: {{ user.roles }}.{% endif %}
```

### Built-in Tags

**assign**
Assigns a value to a variable.

Example:
```
{% assign variable="var_name" %}variable value{% endassign %}
```
---

**comment**
Ignores everything between {% comment %} and {% endcomment %}. An optional note may be inserted in the first tag.

Example:
```
{% comment "Optional note" %}
  Commented out text with
{% endcomment %}
```
---

**cycle**
Produces one of its arguments each time this tag is encountered. The first argument is produced on the first encounter, the second argument on the second encounter, and so forth. Once all arguments are exhausted, the tag cycles to the first argument and produces it again.

Example:
```
{% cycle "odd" "even" %}
```
---

**filter**
Filters the contents of the block through one or more filters. Multiple filters can be specified with pipes and filters can have arguments, just as in variable syntax.
*Note* that the block includes all the text between the filter and endfilter tags.

Example:
```
{% filter lower|capitalize %}
  This TEXT will appear in all capitalize.
{% endfilter %}
```
---

**for**
Loops over each item in an array, making the item available in a context variable.

For example, to display a list of usernames provided in *system.users* list:
```
{% for user in system.users %}
  User: {{ user.name }}
{% endfor %}
```

The for loop sets a number of variables available within the loop:

| Variable | Description |
|----------|-------------|
| forloop.counter     | The current iteration of the loop (1-indexed) |
| forloop.counter0    | The current iteration of the loop (0-indexed) |
| forloop.revcounter  | The number of iterations from the end of the loop (1-indexed) |
| forloop.revcounter0 | The number of iterations from the end of the loop (0-indexed) |
| forloop.first       | True if this is the first time through the loop |
| forloop.last        | True if this is the last time through the loop |
| forloop.parentloop  | For nested loops, this is the loop surrounding the current one |

## Filters

Filters transform the values of variables and tag arguments.

They look like this:
```
{{ name | capitalize }}
```

With a input data of {'name': 'the data processor tool'}, this template renders to:
```
The Data Processor Tool
```

Some filters take an argument:
```
{{ roles | join:"," }}
```

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
