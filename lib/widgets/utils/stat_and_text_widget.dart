import 'package:flutter/material.dart';

class StatAndTextWidget extends StatefulWidget {
  final String stats;
  final String text;
  final Color color;
  final VoidCallback? onTap;

  const StatAndTextWidget({
    super.key,
    required this.stats,
    required this.text,
    this.color = const Color(0xFFFFECB8),
    this.onTap,
  });

  @override
  State<StatAndTextWidget> createState() => _StatAndTextWidgetState();
}

class _StatAndTextWidgetState extends State<StatAndTextWidget> {
  late Color _color;

  @override
  void initState() {
    super.initState();
    _color = widget.color;
  }

  void _onEnter(PointerEvent event) {
    if (widget.onTap != null) {
      setState(() {
        _color = const Color(0xFFECA204);
      });
    }
  }

  void _onExit(PointerEvent event) {
    setState(() {
      _color = widget.color;
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
        child: Column(
          children: [
            Text(
              widget.stats,
              style: TextStyle(
                  color: _color,
                  fontSize: 30.0,
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10.0),
            Text(
              widget.text,
              style: TextStyle(
                color: _color,
                fontSize: 14.0,
                fontFamily: 'Aboreto',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
