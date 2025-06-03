import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomRatingBar extends StatefulWidget {
  final double initialRating;
  final ValueChanged<double>? onChanged;
  final double itemSize;
  final bool ignoreGestures;

  const CustomRatingBar({
    super.key,
    this.initialRating = 0.0,
    this.onChanged,
    this.itemSize = 49,
    this.ignoreGestures = false,
  });

  @override
  State<CustomRatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<CustomRatingBar> {
  late double _currentRating;
  late bool _ignoreGestures;
  late double _itemSize;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
    _ignoreGestures = widget.ignoreGestures;
    _itemSize = widget.itemSize;
  }

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: _currentRating,
      ignoreGestures: _ignoreGestures,
      glowColor: const Color(0xFFECA204),
      allowHalfRating: true,
      itemCount: 5,
      itemSize: _itemSize,
      ratingWidget: RatingWidget(
        full: const Icon(
          CupertinoIcons.drop_fill,
          color: Color(0xFFECA204),
        ),
        half: Stack(
          children: [
            const Icon(
              CupertinoIcons.drop,
              color: Color(0xFFFFECB8), // Color del vacío
            ),
            ClipRect(
              clipper: const _HalfClipper(),
              child: const Icon(
                CupertinoIcons.drop_fill,
                color: Color(0xFFECA204), // Color del lleno
              ),
            ),
          ],
        ),
        empty: const Icon(
          CupertinoIcons.drop,
          color: Color(0xFFFFECB8),
        ),
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _currentRating = rating;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(rating);
        }
      },
    );
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  const _HalfClipper();

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width / 2, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}