import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:semnox/colors/inputs_decorations.dart';
import 'package:semnox/core/utils/extensions.dart';
import 'package:semnox/core/widgets/mulish_text.dart';

class CustomNativeDropdown extends StatelessWidget {
  const CustomNativeDropdown({super.key, required this.items, required this.onChanged});
  final List<String> items;
  final Function(String?) onChanged;
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CustomCupertinoPicker(
        items: items,
        onChanged: onChanged,
      );
    }
    return CustomAndroidPicker(
      items: items,
      onChanged: onChanged,
    );
  }
}

//TODO:Cupertino Picker is snapping to last and first item. Is happening only on iphone emulator?
class CustomCupertinoPicker extends StatefulWidget {
  const CustomCupertinoPicker({super.key, required this.items, required this.onChanged});
  final List<String> items;
  final Function(String?) onChanged;

  @override
  State<CustomCupertinoPicker> createState() => _CustomCupertinoPickerState();
}

class _CustomCupertinoPickerState extends State<CustomCupertinoPicker> {
  late List<String> _items;
  late TextEditingController _controller;
  late FixedExtentScrollController _scrollController;
  late Function(String?) onChanged;
  String? selectedEntitlement;
  @override
  void initState() {
    _items = widget.items;
    _controller = TextEditingController();
    _scrollController = FixedExtentScrollController(initialItem: 0);
    onChanged = widget.onChanged;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Select',
        enabledBorder: CustomInputDecorations.k12RoundedCustomBlue,
        focusedBorder: CustomInputDecorations.k12RoundedCustomBlue,
        errorBorder: CustomInputDecorations.k12RoundedError,
        focusedErrorBorder: CustomInputDecorations.k12RoundedError,
      ),
      validator: (value) => value!.isEmpty ? 'Required' : null,
      onTap: () {
        if (_controller.text.isBlank ?? true) {
          selectedEntitlement ??= _items.first.toLowerCase();
          _controller.text = _items.first.toString();
          onChanged(selectedEntitlement);
        }
        FocusScope.of(context).requestFocus(FocusNode());
        showCupertinoModalPopup(
          semanticsDismissible: true,
          context: context,
          builder: (_) {
            return SizedBox(
              width: double.infinity,
              height: 250,
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 64,
                scrollController: _scrollController,
                onSelectedItemChanged: (index) {
                  _controller.text = _items[index];
                  onChanged(_items[index].toLowerCase());
                },
                children: _items
                    .map(
                      (e) => Center(
                        child: MulishText(
                          text: e.toString(),
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        );
      },
    );
  }
}

class CustomAndroidPicker extends StatelessWidget {
  const CustomAndroidPicker({super.key, required this.onChanged, required this.items});
  final Function(String?) onChanged;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      validator: (value) => value!.toString().isNullOrEmpty() ? 'Required' : null,
      decoration: InputDecoration(
        hintText: 'Select',
        enabledBorder: CustomInputDecorations.k20RoundedCustomBlue,
        focusedBorder: CustomInputDecorations.k20RoundedCustomBlue,
        errorBorder: CustomInputDecorations.k20RoundedError,
        focusedErrorBorder: CustomInputDecorations.k20RoundedError,
      ),
      items: items
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: MulishText(text: e),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
