import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget{
  final TextEditingController controller;
  final String textLabel;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.textLabel,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.autovalidateMode,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;  // Inicializamos el estado de obscureText
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;  // Cambiar el estado de obscureText
    });
  }

  @override
  Widget build(BuildContext context){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 392,
            height: 60,
            decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
            child: TextFormField(
              controller: widget.controller,
              obscureText: _obscureText,
              keyboardType: widget.keyboardType,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary
              ),
              decoration: InputDecoration(
                labelText: widget.textLabel,
                labelStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.60),
                ),
                errorStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Color(0xFF2A7F8C),
                  fontWeight: FontWeight.w800,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                isDense: true,
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary,
                    width: 2.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.surface,
                    width: 2.0,
                  ),
                ),
                suffixIcon: widget.obscureText
                    ? IconButton(
                  icon: _obscureText
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                  color: Color(0xFF351904),
                  onPressed: _toggleObscureText,
                )
                    : null,  // Hace el suffixIcon opcional
              ),
              validator: widget.validator,
              autovalidateMode : widget.autovalidateMode,
              cursorColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          if (widget.validator != null && widget.controller.text.isNotEmpty && widget.validator!(widget.controller.text) != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                widget.validator!(widget.controller.text) ?? '',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Color(0xFF2A7F8C),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
    );
  }
}