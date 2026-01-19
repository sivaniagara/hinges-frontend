import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'long_button.dart';

class CustomDateRangePicker extends StatefulWidget {
  final void Function(PickerDateRange?) onSubmit;
  final VoidCallback onClose;
  final String title;
  final String subTitle;

  const CustomDateRangePicker({
    super.key,
    required this.onSubmit,
    required this.onClose, required this.title, required this.subTitle,
  });

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  PickerDateRange? _selectedRange;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      setState(() {
        _selectedRange = args.value;
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
            selectionMode: DateRangePickerSelectionMode.range,
            initialSelectedRange: PickerDateRange(
              DateTime.now().subtract(const Duration(days: 4)),
              DateTime.now().add(const Duration(days: 3)),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                LongButton(
                    title: 'Submit Date',
                    onPressed: () => widget.onSubmit(_selectedRange),
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
