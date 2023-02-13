import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({
    Key? key,
    required this.onSaved, 
    required this.hintText,
    required this.prefixIcon
  }) : super(key: key);

  final Function(String) onSaved;
  final String hintText;
  final Widget prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: '',
          onSaved: (newValue) => onSaved(newValue!),
          validator: (value) => value!.isEmpty ? 'Required' : null,
          cursorColor: Colors.black,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            isDense: true,
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            prefixIcon: prefixIcon,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
