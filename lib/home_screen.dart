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
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Processar os dados do formulário
      String origin = originController.text;
      String destination = destinationController.text;

      // Aqui você pode adicionar a lógica de envio dos dados
      print('Origem: $origin');
      print('Destino: $destination');
      print('Data Selecionada: ${selectedDateRange != null ? "${selectedDateRange!.start} a ${selectedDateRange!.end}" : "Não selecionada"}');

      // Limpar os campos após o envio, se necessário
      originController.clear();
      destinationController.clear();
      setState(() {
        selectedDateRange = null; // Resetar a seleção de datas
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1000, maxHeight: 1500),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [SizedBox(height: 20), _buildForm()],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(40),
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
            SizedBox(height: 30),
            _buildDropdownRow(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [DropdownWidget(), RadioTypeTicket(), CountPeople()],
    );
  }

  Widget _buildInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildTextField(
            controller: originController,
            icon: CupertinoIcons.search,
            hint: "Local de origem",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório';
              }
              return null;
            },
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: _buildTextField(
            controller: destinationController,
            icon: CupertinoIcons.location,
            hint: "Destino",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório';
              }
              return null;
            },
          ),
        ),
        SizedBox(width: 20),
        Expanded(child: _buildDateDisplay()),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    String? Function(String?)? validator,
  }) {
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
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                ),
                validator: validator,
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
          content: Container(
            width: 300,
            height: 400,
            child: CalendarWidget(
              onDateRangeSelected: _onDateRangeSelected,
              onSingleDateSelected: _onSingleDateSelected,
            ),
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
