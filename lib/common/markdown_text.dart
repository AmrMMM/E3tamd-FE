/// Flattens Markdown to readable plain text - the Dart twin of the backend's
/// `Services/Helpers/MarkdownText.cs`.
///
/// Descriptions are authored as Markdown, but a few places render them as a one-line subtitle where
/// a full Markdown widget would be out of place and raw `##`, `**` and `|` would show through.
///
/// Deliberately a lossy one-way flattening, not a parser: it drops syntax and keeps the words.
/// Emoji are ordinary characters and pass through untouched.
String stripMarkdown(String markdown) {
  if (markdown.trim().isEmpty) return markdown;

  var text = markdown.replaceAll('\r\n', '\n');

  // Fenced code blocks: drop the fences, keep the code.
  text = text.replaceAll(RegExp(r'^[ \t]*(```|~~~).*$', multiLine: true), '');

  // A table's separator row (|---|:---:|) carries no words, so the line goes with its newline -
  // otherwise the header and first row end up split by a blank line.
  text = text.replaceAll(
      RegExp(r'^[ \t]*\|?[ \t]*:?-{2,}:?[ \t]*(\|[ \t]*:?-{2,}:?[ \t]*)*\|?[ \t]*\n?',
          multiLine: true),
      '');

  // Thematic breaks alone on a line.
  text = text.replaceAll(
      RegExp(r'^[ \t]*([-*_])([ \t]*\1){2,}[ \t]*$', multiLine: true), '');

  // Images before links, so alt text survives.
  text = text.replaceAllMapped(
      RegExp(r'!\[([^\]]*)\]\([^)]*\)'), (m) => m.group(1) ?? '');
  text = text.replaceAllMapped(
      RegExp(r'\[([^\]]*)\]\([^)]*\)'), (m) => m.group(1) ?? '');

  // Leading block markers: headings, quotes, list bullets and numbers.
  text = text.replaceAll(
      RegExp(r'^[ \t]*(?:#{1,6}[ \t]+|>[ \t]?|[-*+][ \t]+|\d+[.)][ \t]+)',
          multiLine: true),
      '');

  // Emphasis: the {1,3} run is greedy, so *** is handled before ** before *.
  text = text.replaceAllMapped(
      RegExp(r'(\*{1,3}|_{1,3}|~{2})(?=\S)(.*?\S)\1', dotAll: true),
      (m) => m.group(2) ?? '');
  text = text.replaceAllMapped(RegExp(r'`+([^`]*)`+'), (m) => m.group(1) ?? '');

  // Outer pipes carry no content; inner ones are real cell boundaries, so cells keep a visible
  // separator rather than running together ("Material Aluminium").
  text = text.replaceAll(RegExp(r'^[ \t]*\|[ \t]*', multiLine: true), '');
  text = text.replaceAll(RegExp(r'[ \t]*\|[ \t]*$', multiLine: true), '');
  text = text.replaceAll(RegExp(r'[ \t]*\|[ \t]*'), ' - ');

  text = text.split('\n').map((line) => line.trim()).join('\n');
  text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');

  return text.trim();
}
