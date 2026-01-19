import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'long_button.dart';


class CustomDatePicker extends StatefulWidget {
  final void Function(DateTime?) onSubmit;
  final VoidCallback onClose;
  final String title;
  final String subTitle;

  const CustomDatePicker({
    super.key,
    required this.onSubmit,
    required this.onClose, required this.title, required this.subTitle,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDate;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is DateTime) {
      setState(() {
        _selectedDate = args.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(widget.title, style: Theme.of(context).textTheme.headlineSmall,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(widget.subTitle, style: Theme.of(context).textTheme.labelLarge,),
          ),
          SizedBox(height: 5,),
          SfDateRangePicker(
            selectionColor: Theme.of(context).colorScheme.onPrimaryContainer,
            todayHighlightColor: Theme.of(context).colorScheme.onPrimaryContainer,
            backgroundColor: Colors.transparent,
            onSelectionChanged: _onSelectionChanged,
            selectionMode: DateRangePickerSelectionMode.single,
            initialSelectedDate: DateTime.now(),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                LongButton(
                    title: 'Submit Date',
                    onPressed: () => widget.onSubmit(_selectedDate),
                    outlined: false
                ),
                SizedBox(height: 10,),
                LongButton(
                    title: 'Close',
                    onPressed: () => Navigator.pop(context),
                    outlined: true
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}
