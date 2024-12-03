import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SpellListScreen extends StatefulWidget {
  const SpellListScreen({super.key});

  @override
  State<SpellListScreen> createState() => _SpellListScreenState();
}

class _SpellListScreenState extends State<SpellListScreen> {
  late Future<List<Map<String, String>>> _spells;

  Future<List<Map<String, String>>> fetchSpells() async {
    final url = Uri.parse('https://www.dnd5eapi.co/api/spells');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List;
      return results
          .map((spell) => {
                'name': spell['name'] as String,
                'url': spell['url'] as String,
              },)
          .toList();
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

  @override
  void initState() {
    super.initState();
    _spells = fetchSpells();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spells List'),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _spells,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No spells available.'));
          } else {
            final spells = snapshot.data!;
            return ListView.builder(
              itemCount: spells.length,
              itemBuilder: (context, index) {
                final spell = spells[index];
                return GestureDetector(
                  onTap: () async {
                    final spellDetails = await fetchSpellDetails(spell['url']!);
                    showDialog<void>(
                      // ignore: use_build_context_synchronously
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(spellDetails['name'] as String),
                        content: FutureBuilder<String>(
                          future: Future.delayed(
                            const Duration(milliseconds: 500),
                            () => (spellDetails['desc'] as List)
                                .join('\n'), // Об'єднуємо опис
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == 
                            ConnectionState.waiting) {
                              return const Center(child:
                               CircularProgressIndicator(),);
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(
                                snapshot.data!,
                                style: const TextStyle(color: Colors.black),
                              );
                            }
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, 
                    horizontal: 16,),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(color: Colors.white, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        spell['name']!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
