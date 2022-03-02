import 'package:barbecue/barbecue.dart';
import 'package:io/ansi.dart';
import 'package:markdown/markdown.dart';
import 'package:markdown_ansi_renderer/markdown_ansi_renderer.dart';

String renderMarkdownToANSI(String text) {
  final result = markdownToAnsi(
    text,
    inlineSyntaxes: [UnderlineSyntax(), AnyTagSyntax()],
    blockSyntaxes: [
      AnsiTableSyntax(
        colSpacing: 4,
        cellStyle: CellStyle(
          paddingLeft: 1,
          paddingRight: 1,
        ),
      )
    ],
    tagStyles: AnsiRenderer.defaultTagStyles
      ..['a'] = AnsiLinkStyle(style: '\u001b[94m')
      ..['h2'] = AnsiHeadingStyle(style: lightYellow.escape, transform: (t, _, __) => t.toUpperCase())
      ..['h3'] = AnsiHeadingStyle(style: white.escape, transform: (t, _, __) => t.toUpperCase()),
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
