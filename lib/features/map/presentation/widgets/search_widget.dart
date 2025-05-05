import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onSubmitted;
  final void Function(PointerDownEvent)? onTapOutside;
  final VoidCallback? onCancelTap;
  final String Function(String?)? validate;
  final bool? readOnly;
  final bool? autoFocus;
  final bool? loading;

  const SearchWidget({
    super.key,
    required this.controller,
    this.onTap,
    this.onChange,
    this.onSubmitted,
    this.onTapOutside,
    this.onCancelTap,
    this.validate,
    this.readOnly,
    this.autoFocus,
    this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: AppPallete.whiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextFormField(
          autofocus: autoFocus ?? false,
          readOnly: readOnly ?? false,
          controller: controller,
          onChanged: onChange,
          validator: validate,
          onTap: onTap,
          onTapOutside:
              onTapOutside ??
              (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
          onFieldSubmitted: onSubmitted,
          cursorColor: AppPallete.lightGreyColor,
          keyboardType: TextInputType.text,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppPallete.whiteColor,
            isDense: true,
            hintText: "Search here",
            hintStyle: TextStyle(color: AppPallete.greyColor),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.search, size: 22),
            suffixIcon:
                controller.text.isEmpty
                    ? null
                    : IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed:
                          onCancelTap ??
                          () {
                            controller.clear();
                            onChange?.call('');
                          },
                    ),
          ),
        ),
      ),
    );
  }
}

