import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Seleção de Viajantes')),
        body: Stack(children: [CountPeople()]),
      ),
    );
  }
}

class CountPeople extends StatefulWidget {
  @override
  _ViajantesDropdownState createState() => _ViajantesDropdownState();
}

class _ViajantesDropdownState extends State<CountPeople> {
  int adultos = 1;
  int criancas = 0;
  int bebes = 0;
  bool isExpanded = false;

  void _increment(String tipo) {
    setState(() {
      if (tipo == 'Adultos') adultos++;
      if (tipo == 'Crianças') criancas++;
      if (tipo == 'Bebês' && bebes < adultos) bebes++;
    });
  }

  void _decrement(String tipo) {
    setState(() {
      if (tipo == 'Adultos' && adultos > 1) adultos--;
      if (tipo == 'Crianças' && criancas > 0) criancas--;
      if (tipo == 'Bebês' && bebes > 0) bebes--;
    });
  }

  int _totalViajantes() {
    return adultos + criancas + bebes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${_totalViajantes()} Passageiros",
                  style: TextStyle(fontSize: 16),
                ),
                Icon(isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            width: 280,
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
            ),
            child: Column(
              children: [
                _buildCounterRow(
                  'Adultos',
                  'A partir de 12 anos',
                  adultos,
                  _increment,
                  _decrement,
                ),
                _buildCounterRow(
                  'Crianças',
                  '2 a 11 anos',
                  criancas,
                  _increment,
                  _decrement,
                ),
                _buildCounterRow(
                  'Bebês',
                  '0 a 23 meses',
                  bebes,
                  _increment,
                  _decrement,
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = false;
                    });
                  },
                  child: Text('Confirmar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCounterRow(String titulo, String subtitulo, int valor, Function(String) incrementar, Function(String) decrementar) {
    bool podeAdicionar = _totalViajantes() < 9;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                subtitulo,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => decrementar(titulo),
                icon: Icon(Icons.remove_circle_outline, color: Colors.grey),
              ),
              Text('$valor', style: TextStyle(fontSize: 16)),
              IconButton(
                onPressed: podeAdicionar ? () => incrementar(titulo) : null,
                // Bloqueia se total >= 9
                icon: Icon(
                  Icons.add_circle_outline,
                  color: podeAdicionar ? Colors.blue : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
