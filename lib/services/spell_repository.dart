import 'dart:convert';
import 'package:http/http.dart' as http;

class SpellRepository {
  Future<List<Map<String, String>>> fetchSpells() async {
    final url = Uri.parse('https://www.dnd5eapi.co/api/spells');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List;
      return results.map((spell) {
        return {
          'name': spell['name'] as String,
          'url': spell['url'] as String,
        };
      }).toList();
    } else {
      throw Exception('Failed to load spells');
    }
  }

  Future<Map<String, dynamic>> fetchSpellDetails(String url) async {
    final response = await http.get(Uri.parse('https://www.dnd5eapi.co$url'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load spell details');
    }
  }
}
