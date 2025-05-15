import 'package:flutter/material.dart';

class NavTextButton extends StatefulWidget {
  final String label;
  final Widget destination;
  final double width;

  const NavTextButton({
    super.key,
    required this.label,
    required this.destination,
    this.width = 60,
  });

  @override
  State<NavTextButton> createState() => _NavTextButtonState();
}

class _NavTextButtonState extends State<NavTextButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyLarge ?? const TextStyle();
    final hoverStyle = baseStyle.copyWith(color: const Color(0xFF50B2C0));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget.destination),
          );
        },
        child: SizedBox(
          width: widget.width,
          child: Text(
            widget.label,
            textAlign: TextAlign.right,
            style: _isHovered ? hoverStyle : baseStyle,
          ),
        ),
      ),
    );
  }
}