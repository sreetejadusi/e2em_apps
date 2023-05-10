import 'package:flutter/material.dart';
import '../index_files.dart';

enum TextFieldType { normal, textarea, dropdown, date, datetime, time }

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType keyBoardType;
  final bool enabled, readOnly;
  final String labelText, hintText;
  final List<String> items;
  final TextFieldType type;
  final IconData? suffixIcon;
  final String? Function(String?)? validator;
  final Function(String) onChanged;
  const CustomTextField({
    Key? key,
    required this.labelText,
    this.controller,
    this.keyBoardType = TextInputType.text,
    required this.items,
    required this.type,
    this.enabled = true,
    this.readOnly = false,
    required this.hintText,
    required this.suffixIcon,
    required this.validator,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        textFieldTitle(labelText),
        TextFormField(
          readOnly: !readOnly
              ? ((type == TextFieldType.textarea ||
                      type == TextFieldType.normal)
                  ? false
                  : true)
              : readOnly,
          enabled: enabled,
          keyboardType: keyBoardType,
          cursorColor: cursorColor,
          minLines: type == TextFieldType.textarea ? 4 : 1,
          maxLines: type == TextFieldType.textarea ? 10 : 1,
          controller: controller,
          onTap: () async {
            if (type == TextFieldType.dropdown) {
              showDropdownSearchDialog(
                context: context,
                items: items,
                addEnabled: true,
                onChanged: onChanged,
              );
            } else if (type == TextFieldType.date) {
              final DateTime? selected = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2010),
                lastDate: DateTime(2025),
              );
              if (selected != null) {
                onChanged(selected.toString());
              }
            }
            else if (type == TextFieldType.datetime) {
              final DateTime? selected = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2010),
                lastDate: DateTime(2025),
              );
              if (selected != null) {
                final TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  onChanged(selected.toString());
                }
              }else{}
            } else if (type == TextFieldType.time) {
              final TimeOfDay? selected = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (selected != null) {
                onChanged(selected.toString());
              }
            }
          },
          validator: validator,
          decoration: InputDecoration(
            suffixIcon: Icon(
              suffixIcon,
              color: Colors.black45,
            ),
            border: border,
            enabledBorder: border,
            errorBorder: errorBorder,
            focusedBorder: focusedBorder,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            //hintStyle: hintStyle,
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}
