import 'package:io/ansi.dart';
import 'package:markdown/markdown.dart';
import 'package:markdown_ansi_renderer/markdown_ansi_renderer.dart';

String renderMarkdownToANSI(String text) {
  final result = markdownToAnsi(
    text,
    inlineSyntaxes: [UnderlineSyntax(), AnyTagSyntax()],
    tagStyles: AnsiRenderer.defaultTagStyles
      ..['a'] = AnsiLinkStyle(style: '\u001b[94m')
      ..['h2'] = AnsiBlockStyle(style: lightYellow.escape, transform: (t, _) => t.toUpperCase())
      ..['h3'] = AnsiBlockStyle(style: white.escape, transform: (t, _) => t.toUpperCase()),
  );
  return result;
}

String renderMarkdownToHTML(String text) {
  final result = markdownToHtml(
    text,
    inlineSyntaxes: [UnderlineSyntax()],
  );
  return result;
}
