import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  int? maxLine;
  final String title;
  final String hintText;
  IconData? prefixIcon;
  Widget? suffix;
  bool? enabled;
  String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  TextInputAction? textInputAction;
  void Function(String)? onFieldSubmitted;
  void Function()? onEditingComplete;
  FocusNode? focusNode;
  String? initialValue;
  CustomTextFormField({
    super.key,
    required this.title,
    required this.hintText,
    this.prefixIcon,
    this.suffix,
    this.enabled,
    this.validator,
    this.keyboardType,
    this.onFieldSubmitted,
    this.focusNode,
    this.textInputAction,
    this.initialValue,
    required this.controller,
    this.maxLine
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.bodySmall,),
        TextFormField(
          maxLines: widget.maxLine,
          initialValue: widget.initialValue,
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
          onEditingComplete: widget.onEditingComplete,
          onFieldSubmitted: widget.onFieldSubmitted,
          enabled: widget.enabled,
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              hintText: widget.hintText,
              hintStyle: Theme.of(context).textTheme.bodyMedium,
              prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon,color: Theme.of(context).colorScheme.primaryContainer,) : null,
              suffixIcon: widget.suffix,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)
              )
          ),
        )
      ],
    );
  }
}