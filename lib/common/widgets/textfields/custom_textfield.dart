import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/common/theme/app_colors.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validators;

  const CustomTextfield({
    super.key,
    required this.controller,
    required this.labelText,
    this.validators,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) => widget.validators?.call(value),
      controller: widget.controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.textSecondary.withValues(
              alpha: 0.5,
            ),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        labelText: widget.labelText,
      ),
    );
  }
}
