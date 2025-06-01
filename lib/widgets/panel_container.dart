import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math; // Import for math.max

class ShapedContainer extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;

  const ShapedContainer({
    super.key,
    required this.imageUrl,
    this.width = 200, // Default width for the container
    this.height = 150, // Default height for the container
  });

  @override
  State<ShapedContainer> createState() => _ShapedContainerState();
}

class _ShapedContainerState extends State<ShapedContainer> {
  Future<ui.Image>? _imageFuture;
  // No longer need _svgKey if we're making the ImageShader cover the full maskBounds

  @override
  void initState() {
    super.initState();
    _imageFuture = _loadImage(context, widget.imageUrl);
  }

  Future<ui.Image> _loadImage(BuildContext context, String imageUrl) async {
    final completer = Completer<ui.Image>();
    final imageProvider = NetworkImage(imageUrl);
    final stream = imageProvider.resolve(const ImageConfiguration());
    late ImageStreamListener listener;
    listener = ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
      stream.removeListener(listener);
    }, onError: (dynamic error, StackTrace? stackTrace) {
      completer.completeError(error, stackTrace);
      stream.removeListener(listener);
    });
    stream.addListener(listener);
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        final uiImage = snapshot.data!;
        return SizedBox(
          // Use SizedBox to give ShaderMask explicit dimensions
          width: widget.width,
          height: widget.height,
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (Rect maskBounds) {
              // Calculate scale factors to ensure the image covers the maskBounds
              final double scaleX = maskBounds.width / uiImage.width;
              final double scaleY = maskBounds.height / uiImage.height;

              // Use the larger scale factor to ensure the image covers the entire area
              final double scale = math.max(scaleX, scaleY);

              // Calculate offsets to center the scaled image within maskBounds
              final double offsetX =
                  (maskBounds.width - uiImage.width * scale) / 2;
              final double offsetY =
                  (maskBounds.height - uiImage.height * scale) / 2;

              final matrix = Matrix4.identity()
                ..translate(offsetX, offsetY) // Translate to center the image
                ..scale(scale, scale); // Scale the image uniformly

              return ImageShader(
                uiImage,
                TileMode.clamp,
                TileMode.clamp,
                matrix.storage, // Use .storage to get Float64List
              );
            },
            child: SvgPicture.asset(
              '../../assets/icons/shaped_container.svg',
              // No need for key here as we're not querying its paintBounds directly for the shader
              width:
                  widget.width, // Ensure SVG fills the ShaderMask's child area
              height: widget.height,
              fit:
                  BoxFit.contain, // SVG itself will fit within these dimensions
              colorFilter: const ColorFilter.mode(
                Colors.white, // Makes SVG opaque for masking
                BlendMode.srcIn,
              ),
            ),
          ),
        );
      },
    );
  }
}
