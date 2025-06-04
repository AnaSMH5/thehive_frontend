import 'package:flutter/material.dart';

class HoverAvatar extends StatefulWidget {
  final String? imageUrl;
  final double radius;
  final Function()? onTap;

  const HoverAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 28,
    this.onTap,
  });

  @override
  State<HoverAvatar> createState() => _HoverAvatarState();
}

class _HoverAvatarState extends State<HoverAvatar> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF351904),
                    width: 2.0,
                  ),
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: widget.radius,
                  backgroundColor: const Color(0xFF50B2C0),
                  backgroundImage: (widget.imageUrl != null &&
                          widget.imageUrl is String &&
                          widget.imageUrl!.isNotEmpty)
                      ? NetworkImage(widget.imageUrl!)
                      : null,
                  child: (widget.imageUrl == null || widget.imageUrl == '')
                      ? const Icon(Icons.person, color: Color(0xFFFFECB8))
                      : null,
                )),
            if (_hovering)
              Container(
                width: (widget.radius + 2) * 2,
                height: (widget.radius + 2) * 2,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(128), // 50% opacity
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  color: Color(0xFFFFECB8),
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
