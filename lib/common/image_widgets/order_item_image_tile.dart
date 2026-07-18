import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../logic/interfaces/core_logic.dart';
import '../main_loading.dart';
import 'image_viewer.dart';

/// A client-uploaded order photo. Order responses now carry only the image id, so
/// the tile fetches the bytes on demand (through the resilient HTTP layer), shows
/// them at preview size, and opens the full-screen viewer with those same bytes on
/// tap - no second request.
class OrderItemImageTile extends StatefulWidget {
  final int imageId;
  final double size;

  const OrderItemImageTile({super.key, required this.imageId, this.size = 65});

  @override
  State<OrderItemImageTile> createState() => _OrderItemImageTileState();
}

class _OrderItemImageTileState extends State<OrderItemImageTile> {
  final _core = Injector.appInstance.get<ICoreLogic>();
  Uint8List? _bytes;
  bool _errored = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bytes = await _core.getOrderItemImage(widget.imageId);
    if (_disposed) return;
    setState(() {
      if (bytes == null) {
        _errored = true;
      } else {
        _bytes = bytes;
      }
    });
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errored) {
      return Container(
        width: widget.size,
        height: widget.size,
        color: Colors.black12,
        child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
      );
    }
    if (_bytes == null) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const Center(child: MainLoadinIndicatorWidget()),
      );
    }
    return InkWell(
      onTap: () => showImageViewer(context, MemoryImage(_bytes!)),
      child: Image.memory(
        _bytes!,
        gaplessPlayback: true,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.cover,
      ),
    );
  }
}
