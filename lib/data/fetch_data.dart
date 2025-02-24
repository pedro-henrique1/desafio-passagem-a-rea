import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../result_screen.dart';

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
Future<void> createPassagem(String jsonData, BuildContext context) async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost:8080/proxy/pass'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body.toString());
      String buscaId = responseData['Busca'];
      _buscarVoos(buscaId, context);
    }
  } catch (e) {
    print('Erro na requisição: $e');
  }
}

void _buscarVoos(String buscaId, BuildContext context) async {
  final flightData = await buscarVoos(buscaId);

  if (flightData != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(flightData: flightData)
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erro ao buscar voos!")),
    );
  }
}

// Função para buscar os dados dos voos
Future<Map<String, dynamic>?> buscarVoos(String buscaId) async {
  final url = Uri.parse("http://localhost:8080/proxy/busca/$buscaId");

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Erro ao buscar voos: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Erro na requisição: $e");
    return null;
  }
}

