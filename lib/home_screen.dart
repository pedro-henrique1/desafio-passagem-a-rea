import 'dart:convert';

import 'package:desafio_tecnico/data/fetch_data.dart';
import 'package:desafio_tecnico/widgets/CountDown.dart';
import 'package:desafio_tecnico/widgets/button_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'widgets/CalendarWidget.dart';
import 'widgets/Dropdown.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTimeRange? selectedDateRange;
  SingingCharacter selectedTicketType = SingingCharacter.Ida;
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> originSuggestions = [];
  List<String> destinationSuggestions = [];

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

  bool _isLoading = false;

  void _onOriginChanged(String query) {
    print("Buscando sugestões para: $query");

    if (query.isNotEmpty) {
      setState(() {
        _isLoading = true; // Inicia o carregamento
      });

      fetchSuggestions(query)
          .then((suggestions) {
            setState(() {
              originSuggestions = suggestions;
              _isLoading = false; // Finaliza o carregamento
            });
          })
          .catchError((error) {
            print("Erro ao buscar sugestões: $error");
            setState(() {
              _isLoading = false;
              originSuggestions = [];
            });
          });
    } else {
      setState(() {
        originSuggestions = [];
      });
    }
  }

  void _onDestinationChanged(String query) {
    if (query.isNotEmpty) {
      fetchSuggestions(query).then((suggestions) {
        setState(() {
          destinationSuggestions = suggestions;
        });
      });
    } else {
      setState(() {
        destinationSuggestions = [];
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      String origin = originController.text;
      String destination = destinationController.text;
      String dateIda = DateFormat('dd/MM/yyyy').format(selectedDateRange?.start ?? DateTime.now());
      String dateVolta = DateFormat('dd/MM/yyyy').format(selectedDateRange?.end ?? DateTime.now());
      String selectedTicketType = this.selectedTicketType.name;

      final List<String> selectedAirlines = [
        "AMERICAN AIRLINES",
        "GOL",
        "IBERIA",
        "INTERLINE",
        "LATAM",
        "AZUL",
        "TAP",
      ];

      // Criação do mapa de dados no formato desejado
      final Map<String, dynamic> data = {
        'Companhias': selectedAirlines,
        'DataIda': dateIda,
        'DataVolta': dateVolta,
        'Origem': origin,
        'Destino': destination,
        'Tipo': selectedTicketType,
      };


      final jsonData = jsonEncode(data);

      // Chamando a função para buscar preços
      await createPassagem(jsonData);
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
            ElevatedButton(onPressed: _submitForm, child: Text('Enviar')),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownWidget(),
        RadioTypeTicket(
          onChanged: (SingingCharacter value) {
            setState(() {
              selectedTicketType = value;
            });
          },
        ),
        CountPeople(),
      ],
    );
  }

  Widget _buildInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: _buildTextField(
            controller: originController,
            icon: CupertinoIcons.search,
            hint: "Local de origem",
            onChanged: _onOriginChanged,
            suggestions: originSuggestions,
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
            onChanged: _onDestinationChanged,
            suggestions: destinationSuggestions,
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
    required ValueChanged<String> onChanged,
    required List<String> suggestions,
  }) {
    return Column(
      children: [
        Container(
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
                    onChanged: onChanged,
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
        ),
        if (suggestions.isNotEmpty)
          Container(
            height: 150, // Define um tamanho fixo para rolagem
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(suggestions[index]),
                  onTap: () {
                    controller.text = suggestions[index];
                    setState(() {
                      suggestions.clear(); // Fecha a lista após selecionar
                    });
                  },
                );
              },
            ),
          ),
      ],
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
