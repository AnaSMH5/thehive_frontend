import 'package:flutter/material.dart';

class IconAndTextWidget extends StatefulWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color iconColor;
  final VoidCallback? onTap;

  const IconAndTextWidget({
    super.key,
    required this.icon,
    required this.text,
    this.color = const Color(0xFF351904),
    this.iconColor = const Color(0xFF351904),
    this.onTap,
  });

  @override
  State<IconAndTextWidget> createState() => _IconAndTextWidgetState();
}

class _IconAndTextWidgetState extends State<IconAndTextWidget> {
  late Color _color;
  late Color _iconColor;

  @override
  void initState() {
    super.initState();
    _color = widget.color;
    _iconColor = widget.iconColor;
  }

  void _onEnter(PointerEvent event) {
    if (widget.onTap != null) {
      setState(() {
        _color = const Color(0xFFECA204);
        _iconColor = const Color(0xFFECA204);
      });
    }
  }

  void _onExit(PointerEvent event) {
    setState(() {
      _color = widget.color;
      _iconColor = widget.iconColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          children: [
            Icon(
              widget.icon,
              color: _iconColor,
            ),
            const SizedBox(width: 15.0),
            Text(
              widget.text,
              style: TextStyle(
                color: _color,
                fontSize: 20.0,
                fontFamily: 'Jost',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
