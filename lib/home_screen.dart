import 'package:desafio_tecnico/widgets/CountDown.dart';
import 'package:desafio_tecnico/widgets/button_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/CalendarWidget.dart';
import 'widgets/Dropdown.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTimeRange? selectedDateRange;

  void _onSingleDateSelected(DateTime date) {
    setState(() {
      selectedDateRange = DateTimeRange(start: date, end: date);
    });
  }

  void _onDateRangeSelected(DateTimeRange dateRange) {
    setState(() {
      selectedDateRange = dateRange;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1500, maxHeight: 1500),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildContainer()],
          ),
        ),
      ),
    );
  }

  Widget _buildContainer() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInputFields(),
          SizedBox(height: 20),
          _buildDropdownRow(),
        ],
      ),
    );
  }

  Widget _buildDropdownRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        DropdownWidget(),
        RadioTypeTicket(),
       CountPeople(),
      ],
    );
  }

  Widget _buildInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildTextField(CupertinoIcons.search, "Local de origem")),
        SizedBox(width: 20),
        Expanded(child: _buildTextField(CupertinoIcons.location, "Destino")),
        SizedBox(width: 20),
        Expanded(child: _buildDateDisplay()),
      ],
    );
  }

  Widget _buildTextField(IconData icon, String hint) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 5),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCalendarModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: CalendarWidget(
            onDateRangeSelected: _onDateRangeSelected,
            onSingleDateSelected: _onSingleDateSelected,
          ),
        );
      },
    );
  }

  Widget _buildDateDisplay() {
    return GestureDetector(
      onTap: () => _showCalendarModal(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(CupertinoIcons.calendar_today),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                selectedDateRange != null
                    ? "${selectedDateRange!.start.day}/${selectedDateRange!.start.month}/${selectedDateRange!.start.year} - "
                    "${selectedDateRange!.end.day}/${selectedDateRange!.end.month}/${selectedDateRange!.end.year}"
                    : "Ida e Volta ou apenas Ida",
                style: TextStyle(fontSize: 16, color: Colors.black54),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}