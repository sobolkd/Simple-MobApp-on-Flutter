import 'package:flutter/material.dart';
import 'package:my_project/services/spell_provider.dart';
import 'package:provider/provider.dart';

class SpellListScreen extends StatelessWidget {
  const SpellListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Викликаємо fetchSpells(), щоб почати завантаження даних
    final provider = Provider.of<SpellProvider>(context, listen: false);
    provider.fetchSpells();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spells List'),
      ),
      body: Consumer<SpellProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.errorMessage.isNotEmpty) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          } else if (provider.spells.isEmpty) {
            return const Center(child: Text('No spells available.'));
          } else {
            final spells = provider.spells;
            return ListView.builder(
              itemCount: spells.length,
              itemBuilder: (context, index) {
                final spell = spells[index];
                return GestureDetector(
                  onTap: () async {
                    final spellDetails = await
                     provider.fetchSpellDetails(spell['url']!);
                    showDialog<void>(
                      // ignore: use_build_context_synchronously
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(spellDetails['name'] as String),
                        content: FutureBuilder<String>(
                          future: Future.delayed(
                            const Duration(milliseconds: 500),
                            () => (spellDetails['desc'] as List).join('\n'),
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                             ConnectionState.waiting) {
                              return const 
                              Center(child: CircularProgressIndicator());
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
                    margin: const
                     EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
