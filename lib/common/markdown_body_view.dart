import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;

/// Renders a product description written as Markdown in the admin dashboard.
///
/// Owns the stylesheet so every screen renders descriptions identically. RTL is inherited from the
/// ambient [Directionality], which the details screen already provides.
class MarkdownBodyView extends StatelessWidget {
  final String data;

  /// Style for ordinary paragraphs. Defaults to the grey 15px the details screen used before
  /// descriptions became Markdown, so plain legacy text looks unchanged.
  final TextStyle? paragraphStyle;

  const MarkdownBodyView({super.key, required this.data, this.paragraphStyle});

  @override
  Widget build(BuildContext context) {
    if (data.trim().isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final body = paragraphStyle ??
        const TextStyle(color: Colors.grey, fontSize: 15);
    final heading = TextStyle(
        color: theme.primaryColor, fontWeight: FontWeight.bold);
    final border = Colors.grey.withOpacity(0.4);

    return MarkdownBody(
      data: data,
      // Tables are a GitHub-flavoured extension - without this they render as literal pipes.
      extensionSet: md.ExtensionSet.gitHubFlavored,
      styleSheet: MarkdownStyleSheet(
        p: body,
        listBullet: body,
        a: TextStyle(color: theme.colorScheme.secondary),
        h1: heading.copyWith(fontSize: 20),
        h2: heading.copyWith(fontSize: 18),
        h3: heading.copyWith(fontSize: 16),
        code: body.copyWith(
            fontFamily: 'monospace', backgroundColor: Colors.grey.withOpacity(0.15)),
        blockquote: body.copyWith(fontStyle: FontStyle.italic),
        blockquoteDecoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.08),
          borderRadius: BorderRadius.circular(4),
        ),
        blockquotePadding: const EdgeInsets.all(8),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(top: BorderSide(color: border)),
        ),
        tableHead: body.copyWith(
            color: theme.primaryColor, fontWeight: FontWeight.bold),
        tableBody: body,
        tableBorder: TableBorder.all(color: border),
        tableCellsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      ),
    );
  }
}
