import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final Function(DateTimeRange) onDateRangeSelected;
  final Function(DateTime) onSingleDateSelected;

  const CalendarWidget({
    super.key,
    required this.onDateRangeSelected,
    required this.onSingleDateSelected,
  });

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTimeRange? _selectedDateRange;
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _focusedDay = focusedDay;

        if (_selectedDateRange == null) {
          // Se nenhuma data foi selecionada, armazena a primeira data
          _selectedDateRange = DateTimeRange(start: day, end: day);
          _selectedDay = day;
          widget.onSingleDateSelected(day);
        } else if (_selectedDateRange!.start == _selectedDateRange!.end) {
          // Se já há uma data única selecionada, troca para um intervalo
          _selectedDateRange = DateTimeRange(
            start: _selectedDateRange!.start,
            end: day,
          );
          widget.onDateRangeSelected(_selectedDateRange!);
        } else {
          // Se um intervalo já foi selecionado, redefine para uma nova data única
          _selectedDateRange = DateTimeRange(start: day, end: day);
          _selectedDay = day;
          widget.onSingleDateSelected(day);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<DateTime>(
          focusedDay: _focusedDay,
          firstDay: DateTime.now(),
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
            rangeHighlightColor: Colors.blueGrey,
            rangeStartDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            rangeEndDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          rangeSelectionMode: RangeSelectionMode.toggledOn,
        ),
      ],
    );
  }
}
