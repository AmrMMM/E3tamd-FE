import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

/// Shows a plain-text description clamped to a couple of lines with a "Show more / Show less"
/// toggle. Product descriptions are Markdown and can be long; the compact order-item cards
/// (cart, checkout, my-orders, agent order screens) pass already-flattened text here so the
/// description stays reachable without dominating the card.
///
/// Self-contained state, so it drops into any parent. When the text is short enough to fit within
/// [collapsedMaxLines] no toggle is shown and it renders identically to a plain [Text].
class ExpandableDescription extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int collapsedMaxLines;

  const ExpandableDescription({
    super.key,
    required this.text,
    this.style,
    this.collapsedMaxLines = 2,
  });

  @override
  State<ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription> {
  final _strings = Injector.appInstance.get<IStrings>();
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.text.trim().isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Measure the text at the collapsed limit to decide whether a toggle is even needed.
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: widget.style),
          maxLines: widget.collapsedMaxLines,
          textDirection: Directionality.of(context),
        )..layout(maxWidth: constraints.maxWidth);

        if (!painter.didExceedMaxLines) {
          return Text(widget.text, style: widget.style);
        }

        final toggleColor = widget.style?.color;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.text,
              style: widget.style,
              maxLines: _expanded ? null : widget.collapsedMaxLines,
              overflow:
                  _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _strings.getStrings(_expanded
                          ? AllStrings.showLessTitle
                          : AllStrings.showMoreTitle),
                      style: TextStyle(
                        color: toggleColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                      color: toggleColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
