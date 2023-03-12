import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import "package:flutter/material.dart";
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  DatePicker(
      {required this.label,
      required this.onChanged,
      this.required = false,
      // this.initialValue,
      this.border = false,
      super.key});

  final String label;
  // final DateTime? initialValue;
  final dynamic Function(DateTime value) onChanged;
  bool required;

  final bool border;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  TextEditingController dateController = TextEditingController();
  // DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    dateController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dateController,
      decoration: InputDecoration(
        icon: const Icon(Icons.calendar_today),
        labelText: widget.label,
        enabledBorder:
            widget.border ? const UnderlineInputBorder() : InputBorder.none,
      ),
      readOnly: true,
      validator: (value) {
        if (widget.required && (value == null || value.isEmpty)) {
          return "Please enter a date";
        }
      },
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          String formatted = DateFormat("MM/dd/yyyy").format(pickedDate);
          setState(() {
            dateController.text = formatted;
            // selectedDate = pickedDate;
          });
          widget.onChanged(pickedDate);
        } else {
          // print("Date is not selected");
        }
      },
    );
  }
}
