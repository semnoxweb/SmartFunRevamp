import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
    Key? key,
    required this.labelText,
    this.hintText = "",
    required this.format,
    this.initialDateTime,
    this.maximunDateTime,
    required this.onItemSelected,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);
  final String labelText;
  final String hintText;
  final String format;
  final DateTime? initialDateTime;
  final DateTime? maximunDateTime;
  final Function(DateTime) onItemSelected;
  final EdgeInsetsGeometry margin;

  @override
  State<StatefulWidget> createState() {
    return _CustomDatePickerState();
  }
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final TextEditingController _controller = TextEditingController(text: '');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextFormField(
            keyboardType: TextInputType.none,
            controller: _controller,
            readOnly: true,
            onTap: () {
              if (Platform.isAndroid) {
                _showAndroidDatePicker(context);
              } else {
                _showiOSPicker(context);
              }
            },
            decoration: InputDecoration(
              isDense: true,
              fillColor: Colors.transparent,
              filled: true,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAndroidDatePicker(ctx) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.initialDateTime ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: widget.maximunDateTime ?? DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _controller.text = DateFormat(widget.format).format(pickedDate);
        widget.onItemSelected(pickedDate);
      });
    }
  }

  void _showiOSPicker(ctx) {
    showCupertinoModalPopup(
      context: ctx,
      builder: (_) => Container(
        height: 250,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: CupertinoDatePicker(
                  maximumYear: widget.maximunDateTime?.year ?? DateTime.now().year,
                  initialDateTime: widget.initialDateTime,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (date) {
                    setState(() {
                      _controller.text = DateFormat(widget.format).format(date);
                      widget.onItemSelected(date);
                    });
                  }),
            ),
            CupertinoButton(
              child: const Text('Done'),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ],
        ),
      ),
    );
  }
}