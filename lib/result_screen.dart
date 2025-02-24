import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> flightData;

  const ResultScreen({Key? key, required this.flightData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> voos = flightData['Voos'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes da Busca"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: voos.length,
          itemBuilder: (context, index) {
            var voo = voos[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Companhia: ${voo['Companhia']}", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Sentido: ${voo['Sentido']}", style: TextStyle(fontSize: 16)),
                    Text("Origem: ${voo['Origem']} - Destino: ${voo['Destino']}", style: TextStyle(fontSize: 16)),
                    Text("Embarque: ${voo['Embarque']}", style: TextStyle(fontSize: 16)),
                    Text("Desembarque: ${voo['Desembarque']}", style: TextStyle(fontSize: 16)),
                    Text("Duração: ${voo['Duracao']}", style: TextStyle(fontSize: 16)),
                    Text("Número do Voo: ${voo['NumeroVoo']}", style: TextStyle(fontSize: 16)),

                    if (voo['NumeroConexoes'] > 0) ...[
                      SizedBox(height: 10),
                      Text("Conexões:", style: TextStyle(fontWeight: FontWeight.bold)),
                      ...voo['Conexoes'].map<Widget>((conexao) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Voo: ${conexao['NumeroVoo']}", style: TextStyle(fontSize: 16)),
                            Text("Origem: ${conexao['Origem']} - Destino: ${conexao['Destino']}", style: TextStyle(fontSize: 16)),
                            Text("Embarque: ${conexao['Embarque']} - Desembarque: ${conexao['Desembarque']}", style: TextStyle(fontSize: 16)),
                            Text("Duração: ${conexao['Duracao']}", style: TextStyle(fontSize: 16)),
                          ],
                        );
                      }).toList(),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Exemplo de uso:
// Navigator.push(context, MaterialPageRoute(builder: (context) => FlightDetailsScreen(flightData: jsonData)));
