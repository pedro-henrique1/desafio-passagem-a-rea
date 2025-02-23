import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<String>> fetchSuggestions(String query) async {
  final url = Uri.parse("http://localhost:8080/proxy/aeroportos?q=$query");

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item['Nome'] as String).toList();
    } else {
      print("Erro na API: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print("Erro ao buscar sugestões: $e");
    return [];
  }
}



