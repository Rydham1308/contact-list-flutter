import 'package:contacts/constants/validation/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.icon,
    this.validType,
    this.isObscureText,
    this.suffixIcon,
    this.textInputType,
    this.maxLength,
    this.prefixIconColor,
    this.isEnable,
  });

  final int? maxLength;
  final TextEditingController? controller;
  final String? hintText;
  final IconData? icon;
  final String? validType;
  final bool? isObscureText;
  final bool? isEnable;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final Color? prefixIconColor;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.isEnable ?? true,
      keyboardType: widget.textInputType,
      inputFormatters: [
        LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      obscureText: widget.isObscureText ?? false,
      controller: widget.controller,
      validator: (value) {
        switch (widget.validType) {
          case 'phone':
            {
              if (value!.isEmpty) {
                return "Required";
              } else if (value.isValidPhone == false) {
                return "Enter valid mobile no.";
              } else {
                return null;
              }
            }
          case 'password':
            {
              if (value!.isEmpty) {
                return "Required";
              } else if (widget.controller?.text.isValidPassword == false) {
                return "Password should include at-least one Capital, Small, Number & Spacial Char.";
              } else if (value.length < 6) {
                return "Password should be at-least 6 characters.";
              } else if (value.length > 15) {
                return "Password should not be greater than 15 characters.";
              } else {
                return null;
              }
            }
          case 'email':
            {
              if (value!.isEmpty) {
                return "Required";
              } else if (value.isValidEmail == false) {
                return "Enter valid email.";
              } else {
                return null;
              }
            }
          default:
            {
              if (value!.isEmpty) {
                return "Required";
              } else {
                return null;
              }
            }
        }
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.icon,
          color: widget.prefixIconColor,
          size: 16,
        ),
        suffixIcon: widget.suffixIcon,
        errorStyle: const TextStyle(
          fontSize: 10,
        ),
        errorMaxLines: 3,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade400,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade400,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade400,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade400,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade400,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
            width: 1,
          ),
        ),
      ),
    );
  }
}
