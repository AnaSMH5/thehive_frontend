import 'package:flutter/material.dart';

class NavTextButton extends StatefulWidget {
  final String label;
  final Widget? destination;
  final VoidCallback? onTap;
  //final double width;

  const NavTextButton({
    super.key,
    required this.label,
    this.destination,
    this.onTap,
    //this.width = 60,
  }) : assert(
            (destination == null && onTap != null) ||
                (destination != null && onTap == null),
            'Debe proveer destination o onTap');

  @override
  State<NavTextButton> createState() => _NavTextButtonState();
}

class _NavTextButtonState extends State<NavTextButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final baseStyle =
        Theme.of(context).textTheme.bodyLarge ?? const TextStyle();
    final hoverStyle = baseStyle.copyWith(color: const Color(0xFF50B2C0));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TextButton(
        onPressed: () {
          if (widget.onTap != null) {
            widget.onTap!();
          } else if (widget.destination != null) {
            final currentRoute = ModalRoute.of(context);
            final destinationType = widget.destination.runtimeType;

            final isSamePage = currentRoute?.settings.name == destinationType.toString();

            if (!isSamePage) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => widget.destination!),
              );
            }
          }
        },
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
              EdgeInsets.only(left: 19, right: 0)), // Usa WidgetStateProperty
        ),
        child: SizedBox(
          //width: widget.width,
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
