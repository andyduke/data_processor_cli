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

#### assign
Assigns a value to a variable.

Example:
```
{% assign variable="var_name" %}variable value{% endassign %}
```
---

#### comment
Ignores everything between {% comment %} and {% endcomment %}. An optional note may be inserted in the first tag.

Example:
```
{% comment "Optional note" %}
  Commented out text with
{% endcomment %}
```
---

#### cycle
Produces one of its arguments each time this tag is encountered. The first argument is produced on the first encounter, the second argument on the second encounter, and so forth. Once all arguments are exhausted, the tag cycles to the first argument and produces it again.

Example:
```
{% cycle "odd" "even" %}
```
---

#### filter
Filters the contents of the block through one or more filters. Multiple filters can be specified with pipes and filters can have arguments, just as in variable syntax.
*Note* that the block includes all the text between the filter and endfilter tags.

Example:
```
{% filter lower|capitalize %}
  This TEXT will appear in all capitalize.
{% endfilter %}
```
---

#### for
Loops over each item in an array, making the item available in a context variable.

For example, to display a list of usernames provided in *system.users* list:
```
{% for user in system.users %}
  User: {{ user.name }}
{% endfor %}
```

The for loop sets a number of variables available within the loop:

| Variable            | Description                                                     |
|---------------------|-----------------------------------------------------------------|
| forloop.counter     | The current iteration of the loop (1-indexed)                   |
| forloop.counter0    | The current iteration of the loop (0-indexed)                   |
| forloop.revcounter  | The number of iterations from the end of the loop (1-indexed)   |
| forloop.revcounter0 | The number of iterations from the end of the loop (0-indexed)   |
| forloop.first       | True if this is the first time through the loop                 |
| forloop.last        | True if this is the last time through the loop                  |
| forloop.parentloop  | For nested loops, this is the loop surrounding the current one  |

---

#### for...empty
The for tag can take an optional `{% empty %}` clause whose text is displayed if the given array is empty or could not be found:
```
{% for user in users %}
  * {{ user.name }}
{% empty %}
  Sorry, no users in this list.
{% endfor %}
```

The above is equivalent to - but shorter, cleaner, and possibly faster than - the following:
```
{% if users %}
  {% for user in users %}
    * {{ user.name }}
  {% endfor %}
{% else %}
  Sorry, no users in this list.
{% endif %}
```
---

#### if
The `{% if %}` tag evaluates a variable, and if that variable is "true" (i.e. exists, is not empty, and is not a false boolean value) the contents of the block are output:

```
{% if users %}
  Number of users: {{ users|length }}
{% elif privileged_users %}
  Number of privileged users: {{ privileged_users|length }}
{% else %}
  No users.
{% endif %}
```

In the above, if users is not empty, the number of users will be displayed by the `{{ users|length }}` variable.

As you can see, the if tag may take one or several `{% elif %}` clauses, as well as an `{% else %}` clause that will be displayed if all previous conditions fail. These clauses are optional.

##### Boolean operators

`if` tags may use `and`, `or` or `not` to test a number of variables or to negate a given variable:

**and**
```
{% if users and managers %}
  Both users and managers are available.
{% endif %}
```

**not**
```
{% if not users %}
  There are no users.
{% endif %}
```

**or**
```
{% if users or managers %}
  There are some users or some managers.
{% endif %}
```

**not & or**
```
{% if not users or managers %}
  There are no users or there are some managers.
{% endif %}
```

**and & not**
```
{% if users and not managers %}
  There are some users and absolutely no managers.
{% endif %}
```

Use of both `and` and `or` clauses within the same tag is allowed, with `and` having higher precedence than `or` e.g.:
```
{% if users and managers or customers %}
```
will be interpreted like:
```
if (users and managers) or customers
```

Use of actual parentheses in the `if` tag is invalid syntax. If you need them to indicate precedence, you should use nested `if` tags.

---

`if` tags may also use the operators `==`, `!=`, `<`, `>`, `<=`, `>=`, `in`, `not in`, `is`, and `is not`.

---

#### by_path

Returns the value obtained using the *JMESPath*.

For example:
```
{% by_path "customers[?age > `30`]" %}
```

If the input data:
```
{
  "customers": [
    {
      "name": "John",
      "age": 56
    },
    {
      "name": "Richard",
      "age": 29
    }
  ]
}
```

the template will output:
```
{
  "name": "John",
  "age": 56
}
```
---

#### with

Stores the value obtained using the *JMESPath* into a variable. This is convenient for reusing such a value.

For example:
```
{% with entries as "customers[?age > `30`]" %}
  {%- for entry in entries -%}
  - {{ entry.name }}
    {{ entry.age }}
  {%- endfor -%}

  Total: {{ entries|length }}
{% endwith -%}
```

If the input data:
```
{
  "customers": [
    {
      "name": "John",
      "age": 56
    },
    {
      "name": "Richard",
      "age": 29
    }
  ]
}
```

the template will output:
```
  - John
    56

  Total: 1
```
---


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

### Built-in Filters

#### default

If value evaluates to `False`, uses the given default. Otherwise, uses the value.

For example:
```
{{ value|default:"nothing" }}
```

If `value` is "" (the empty string), the output will be `nothing`.

---

#### default_if_none

If (and only if) value is `None`, uses the given default. Otherwise, uses the value.

Note that if an empty string is given, the default value will not be used. Use the `default` filter if you want to fallback for empty strings.

For example:
```
{{ value|default_if_none:"nothing" }}
```

If `value` is `None`, the output will be `nothing`.

---

#### length

Returns the length of the list.

For example:
```
{{ value|length }}
```
If value is `['a', 'b', 'c', 'd']`, the output will be `4`.

The filter returns `0` for a non-list variable.

---

#### lower

Converts a string into all lowercase.

---

#### upper

Converts a string into all uppercase.

---

#### capitalize

Capitalizes the first character of the value. If the first character is not a letter, this filter has no effect.

---

#### join

Joins a list with a string.

For example:
```
{{ value|join:" // " }}
```

If `value` is the list `['a', 'b', 'c']`, the output will be the string `"a // b // c"`.

---

#### query

Applies a *JMESPath* to the value of a variable.

For example:
```
{% for entry in data | query: "customers[?age > `30`]" -%}
- {{ entry.name }}
  {{ entry.age }}
{%- endfor -%}
```

If the input data:
```
{
  "data": {
    "customers": [
      {
        "name": "John",
        "age": 56
      },
      {
        "name": "Richard",
        "age": 29
      }
    ]
  }
}
```

the template will output:
```
  - John
    56
```


---

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
