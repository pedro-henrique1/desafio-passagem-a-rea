import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/CalendarWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTimeRange? selectedDateRange;

  void _onSingleDateSelected(DateTime date) {
    setState(() {
      selectedDateRange = DateTimeRange(start: date, end: date); // Armazena a data única como um intervalo
    });
    print("Data única selecionada: ${date.toLocal()}");
  }

  void _onDateRangeSelected(DateTimeRange dateRange) {
    setState(() {
      selectedDateRange = dateRange;
    });
    print("Intervalo de datas selecionado: ${dateRange.start.toLocal()} - ${dateRange.end.toLocal()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 100),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              children: [
                _buildTextField(CupertinoIcons.search, "Local de origem"),
                SizedBox(width: 10),
                _buildTextField(CupertinoIcons.location, "Destino"),
                SizedBox(width: 10),
                _buildDateDisplay(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint) {
    return Container(
      width: 250,
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

  Widget _buildCalendarWidget(context) {
    return SizedBox(
      child: CalendarWidget(onDateRangeSelected: _onDateRangeSelected,
        onSingleDateSelected: _onSingleDateSelected),
    );
  }

  void _showCalendarModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: _buildCalendarWidget(context),
        );
      },
    );
  }

  Widget _buildDateDisplay() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        width: 350,
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
              child: GestureDetector(
                onTap: () => _showCalendarModal(context),
                child: Text(
                  selectedDateRange != null
                      ? "${selectedDateRange!.start.day}/${selectedDateRange!.start.month}/${selectedDateRange!.start.year} - "
                      "${selectedDateRange!.end.day}/${selectedDateRange!.end.month}/${selectedDateRange!.end.year}"
                      : "Ida e Volta ou apenas Ida",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
