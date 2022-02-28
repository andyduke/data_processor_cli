import 'package:data_processor/markdown.dart';

typedef GuideOutput = void Function(String message);
typedef GuideIntro = String Function();

abstract class Guide {
  abstract final String title;
  abstract final String text;

  final GuideOutput out;
  final GuideIntro? intro;

  Guide(
    this.out, {
    this.intro,
  });

  void display(String? format) {
    String header = '';
    String footer = '';
    String introBegin = '';
    String introEnd = '';

    late final String result;

    if (format == 'md') {
      result = text;
    } else if (format == 'html') {
      // TODO: Prepend CSS & HTML prologue

      header = '''
<!DOCTYPE html>
<html>
<head>
  <title>$title</title>
  <meta charset="UTF-8" />
  <style type="text/css">
    $_css
  </style>
</head>
<body>
''';
      footer = '''
</body>
</html>
''';

      introBegin = '<div class="copyright"><a href="https://github.com/andyduke/data_processor">';
      introEnd = '</a></div>';

      result = renderMarkdownToHTML(text);
    } else {
      result = renderMarkdownToANSI(text);
    }

    // ---

    out(header);

    if (intro != null) {
      out(introBegin);
      out(intro!.call());
      out(introEnd);
    }

    out(result);

    out(footer);
  }

  final String _css = '''
body {
  font-family: "Segoe UI", Roboto, sans-serif;
  font-size: 16px;
  line-height: 1.25;
  color: #222222;
  background-color: white;
  padding: 20px;
  padding-bottom: 40px;
}

.copyright {
  font-size: 16px;
  font-weight: bold;
  color: #777;

  padding-bottom: 6px;
  border-bottom: 2px solid #ccc;
  margin-bottom: 16px;
}
.copyright a {
  text-decoration: none;
}

a {
  color: #009494;
}
a:hover {
  color: #00ADAD;
}

h2, h3, h4, h5, h6 {
  margin-top: 36px;
}

code {
  color: white;
  background-color: #333;
  padding-left: 4px;
  padding-right: 4px;
  border-radius: 2px;
}

pre {
  padding: 8px 12px;
  color: white;
  border-radius: 4px;
  background-color: #333;
}
pre code {
  padding: 0;
}

''';
}
