import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isRequired;
  final bool isMultiline;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomFormField({
    super.key,
    required this.label,
    this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isRequired = true,
    this.isMultiline = false,
    this.validator,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.focusNode,
    this.onEditingComplete,
    this.textInputAction,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              children: [
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            focusNode: focusNode,
            onEditingComplete: onEditingComplete,
            textInputAction: textInputAction,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: ColorConstants.primaryColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red.shade300, width: 1),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              counterText: '',
            ),
            keyboardType: isMultiline ? TextInputType.multiline : keyboardType,
            maxLines: isMultiline ? 3 : 1,
            maxLength: maxLength,
            obscureText: obscureText,
            validator:
                validator ??
                (isRequired
                    ? (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '$label is required';
                      }
                      return null;
                    }
                    : null),
          ),
        ],
      ),
    );
  }
}
