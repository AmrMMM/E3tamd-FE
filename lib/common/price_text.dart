import 'package:flutter/material.dart';

/// Single source of truth for how a price is rendered across the app: the Saudi
/// Riyal symbol, number formatting, and the symbol-before-amount placement.
///
/// The symbol is drawn as a glyph from a bundled font (family [riyalFontFamily])
/// rather than a raw Unicode character, because the new Riyal code point is
/// absent from the system fonts on most in-field devices and would otherwise
/// show a tofu box. Bundling the font is the only thing that has to happen
/// outside this file (see pubspec.yaml + fonts/README.md).

// Must match the family declared in pubspec.yaml's fonts: block.
const String riyalFontFamily = "SaudiRiyal";

// SAUDI RIYAL SIGN. Must match the code point the bundled font maps the glyph to
// (this font uses U+20C1; U+E900 is its legacy private-use alternative).
const String riyalGlyph = "\u20C1";

// The glyph reads visually smaller than the digits at the same font size, so the
// symbol is scaled up a little to match. Tweak to taste.
const double riyalSymbolScale = 1.35;

// Thin space between the symbol and the number.
const String _thinSpace = " ";

/// Formats a monetary amount. Kept as the number's natural string (e.g. `115.0`)
/// so displayed values match what the app showed before the symbol change.
String formatAmount(num value) {
  return value.toString();
}

/// The Riyal symbol as an inline span, for `RichText`/`Text.rich` call sites that
/// build their own spans (e.g. a "Price : " prefix). Pass the surrounding text's
/// [fontSize]/[color] so the symbol matches it.
InlineSpan riyalSymbolSpan({double? fontSize, Color? color}) {
  return TextSpan(
    text: riyalGlyph,
    style: TextStyle(
      fontFamily: riyalFontFamily,
      fontSize: fontSize == null ? null : fontSize * riyalSymbolScale,
      color: color,
    ),
  );
}

// Unicode bidi isolates: force the enclosed run to lay out left-to-right no matter
// the surrounding paragraph direction.
const String _lri = "⁦"; // LEFT-TO-RIGHT ISOLATE
const String _pdi = "⁩"; // POP DIRECTIONAL ISOLATE

/// The whole `<symbol> <amount>` as one inline span, for prices embedded inside a
/// sentence (e.g. "Price : ⃁ 100"). Isolated so the symbol stays on the LEFT of the
/// number even on an Arabic (RTL) screen, without flipping the surrounding words.
InlineSpan priceSpan(num amount, {double? fontSize, Color? color}) {
  return TextSpan(children: [
    const TextSpan(text: _lri),
    riyalSymbolSpan(fontSize: fontSize, color: color),
    const TextSpan(text: _thinSpace),
    TextSpan(text: formatAmount(amount)),
    const TextSpan(text: _pdi),
  ]);
}

/// Renders `<symbol> <amount>` (symbol first, on the left) for a price. Drop-in
/// replacement for the old `Text("$amount SAR")` sites; [style] applies to the
/// number and the symbol is matched to it. Forced left-to-right so the symbol
/// stays on the left even in an Arabic (RTL) screen.
class PriceText extends StatelessWidget {
  final num amount;
  final TextStyle? style;
  final TextAlign? textAlign;

  const PriceText(this.amount, {Key? key, this.style, this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effective = DefaultTextStyle.of(context).style.merge(style);
    return Text.rich(
      TextSpan(
        style: effective,
        children: [
          riyalSymbolSpan(fontSize: effective.fontSize, color: effective.color),
          const TextSpan(text: _thinSpace),
          TextSpan(text: formatAmount(amount)),
        ],
      ),
      textAlign: textAlign,
      textDirection: TextDirection.ltr,
    );
  }
}
