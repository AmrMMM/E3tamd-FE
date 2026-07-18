import 'dart:convert';
import 'dart:typed_data';

// Keyed by the encoded thumbnail STRING (its content), not by list position or a
// model id. So the same bytes instance is returned across rebuilds - which lets
// Image.memory hit the image cache instead of re-decoding and flashing - while a
// changed image (different content) naturally gets a new entry. Reordering,
// adding, or removing list items can never return the wrong image.
final Map<String, Uint8List> _thumbnailCache = <String, Uint8List>{};
const int _thumbnailCacheLimit = 300;

/// Decodes an inline thumbnail delivered by the API. The backend sends a `data:` URI
/// (e.g. `data:image/jpeg;base64,....`), but a bare base64 string is also accepted as a
/// fallback. Returns null for null/empty/invalid input so callers can fall back to the
/// full-size image endpoint. Results are memoized by content so repeated builds reuse
/// the same decoded bytes.
Uint8List? decodeThumbnail(String? value) {
  if (value == null || value.isEmpty) return null;

  final cached = _thumbnailCache[value];
  if (cached != null) return cached;

  try {
    final Uint8List bytes = value.startsWith('data:')
        ? UriData.parse(value).contentAsBytes()
        : base64Decode(value);

    // Coarse cap so the cache can't grow unbounded over a long session; clearing
    // wholesale is fine since entries are cheap to rebuild on demand.
    if (_thumbnailCache.length >= _thumbnailCacheLimit) _thumbnailCache.clear();
    _thumbnailCache[value] = bytes;
    return bytes;
  } catch (_) {
    return null;
  }
}
