import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final Function(DateTimeRange) onDateRangeSelected;

  const CalendarWidget({super.key, required this.onDateRangeSelected});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTimeRange? _selectedDateRange;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      _selectedDay = day;
      _focusedDay = focusedDay;
    });

    if (_selectedDateRange == null) {
      _selectedDateRange = DateTimeRange(start: day, end: day);
    } else if (_selectedDateRange!.start == _selectedDateRange!.end) {
      if (day.isBefore(_selectedDateRange!.start)) {
        _selectedDateRange = DateTimeRange(start: day, end: _selectedDateRange!.start);
      } else {
        _selectedDateRange = DateTimeRange(start: _selectedDateRange!.start, end: day);
      }
    } else {
      _selectedDateRange = DateTimeRange(start: day, end: day);
    }

    if (_selectedDateRange!.start.isBefore(_selectedDateRange!.end)) {
      widget.onDateRangeSelected(_selectedDateRange!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: TableCalendar(
          focusedDay: _focusedDay,
          firstDay: DateTime(2000),
          lastDay: DateTime(2111),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDateRange?.start, day) ||
                isSameDay(_selectedDateRange?.end, day);
          },
          rangeStartDay: _selectedDateRange?.start,
          rangeEndDay: _selectedDateRange?.end,
          onDaySelected: _onDaySelected,
          calendarStyle: const CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            rangeHighlightColor: Colors.lightBlue,
            rangeStartDecoration: BoxDecoration(
              color: Colors.indigo,
              shape: BoxShape.circle,
            ),
            rangeEndDecoration: BoxDecoration(
              color: Colors.indigo,
              shape: BoxShape.circle,
            ),
          ),
          rangeSelectionMode: RangeSelectionMode.toggledOn,
        ),
      ),
    );
  }
}
