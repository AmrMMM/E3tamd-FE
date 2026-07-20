import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageCarousel extends StatefulWidget {
  final List<Widget> images;
  final bool autoSlide;
  final Brightness brightness;
  final double? aspectRatio;
  final bool flat;
  final double? height;

  /// Notified whenever the visible page changes, so a caller rendering its own controls (a
  /// thumbnail strip, a counter) can follow along.
  final void Function(int index)? onPageChanged;

  /// Lets a caller drive the carousel from outside - the product gallery uses it to jump to the
  /// image whose thumbnail was tapped.
  final ImageCarouselController? controller;

  /// Hides the built-in dot row for callers that render their own page indicator.
  final bool showIndicators;

  /// How much of the viewport each page occupies. The 0.8 default keeps the classic "peek" of the
  /// neighboring slides (the offers screen look); 1.0 renders each image full-width.
  final double viewportFraction;

  const ImageCarousel(
      {super.key,
      required this.images,
      this.autoSlide = true,
      this.brightness = Brightness.dark,
      this.aspectRatio,
      this.height,
      this.flat = false,
      this.onPageChanged,
      this.controller,
      this.showIndicators = true,
      this.viewportFraction = 0.8});

  @override
  ImageCarouselState createState() => ImageCarouselState();
}

/// Handle a parent holds to move the carousel. Kept separate from carousel_slider's own controller
/// so callers don't have to import that package.
class ImageCarouselController {
  void Function(int index)? _animateToPage;

  void animateToPage(int index) => _animateToPage?.call(index);
}

class ImageCarouselState extends State<ImageCarousel> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  Widget getImageContainer(Widget img) => ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        child: img,
      );

  @override
  void initState() {
    super.initState();
    widget.controller?._animateToPage = _controller.animateToPage;
  }

  @override
  void dispose() {
    widget.controller?._animateToPage = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CarouselSlider(
        items: widget.images.map(getImageContainer).toList(),
        carouselController: _controller,
        options: CarouselOptions(
            autoPlay: widget.autoSlide,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: !widget.flat,
            viewportFraction: widget.viewportFraction,
            height: widget.height,
            aspectRatio: widget.aspectRatio ?? (16 / 9),
            disableCenter: true,
            pageSnapping: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
              widget.onPageChanged?.call(index);
            }),
      ),
      if (widget.showIndicators)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.images.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (widget.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
    ]);
  }
}
