import 'package:flutter/material.dart';
import '../../config/colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool showPasswordToggle;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textGray,
            letterSpacing: 0.08,
          ),
        ),
        SizedBox(height: 7),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.bgSecondary,
            border: Border.all(
              color: AppColors.border,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: _obscureText,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
              ),
              suffixIcon: widget.showPasswordToggle
                  ? IconButton(
                      onPressed: () {
                        setState(() => _obscureText = !_obscureText);
                      },
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      padding: EdgeInsets.only(right: 8),
                      constraints: BoxConstraints(),
                    )
                  : null,
            ),
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textGray,
            letterSpacing: 0.08,
          ),
        ),
        SizedBox(height: 6),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColors.primary,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              underline: SizedBox(),
              isExpanded: true,
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
