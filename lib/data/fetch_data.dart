import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<String>> fetchSuggestions(String query) async {
  final url = Uri.parse("http://localhost:8080/proxy/aeroportos?q=$query");

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item['Iata'] as String).toList();
    } else {
      print("Erro na API: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print("Erro ao buscar sugestões: $e");
    return [];
  }
}

Future<void> createPassagem(String jsonData) async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost:8080/proxy/pass'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );
    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body.toString());
      String buscaId = responseData['Busca'];
      buscarPassagens(buscaId);
    }
  } catch (e) {
    print('Erro na requisição: $e');
  }
}

Future<void> buscarPassagens(String idBusca) async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost:8080/proxy/busca/$idBusca'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('Passagens obtidas: $responseData');
    } else {
      print('Erro ao buscar passagens: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro na requisição: $e');
  }
}
