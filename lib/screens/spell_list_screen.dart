import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SpellListScreen extends StatelessWidget {
  const SpellListScreen({super.key});

  Future<List<String>> fetchSpells() async {
    final url = Uri.parse('https://www.dnd5eapi.co/api/spells');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final spells = data['results'] as List;
      return spells.map((spell) => spell['name'] as String).toList();
    } else {
      throw Exception('Failed to load spells');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spells List'),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchSpells(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No spells available.',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            final spells = snapshot.data!;
            return ListView.builder(
              itemCount: spells.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    spells[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            );
          }
        },
      ),
      backgroundColor: Colors.black, // Щоб білий текст був читабельним
    );
  }
}
