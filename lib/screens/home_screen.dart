import 'package:flutter/material.dart';
import 'package:my_project/database_helper.dart';
import 'package:my_project/screens/create_character_screen.dart';
import 'package:my_project/screens/profile_screen.dart';
import 'package:my_project/widgets/character_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _characters = [];

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    final dbHelper = DatabaseHelper();
    final characters = await dbHelper.getCharacters();
    setState(() {
      _characters = characters;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Characters'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _characters.isEmpty
          ? const Center(
              child: Text(
                'No characters created yet.',
                style: TextStyle(fontSize: 20),
              ),
            )
          : CharacterListWidget(
              characters: _characters,
              onDelete: _loadCharacters,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateCharacterScreen(),
            ),
          );
          if (result == true) {
            _loadCharacters();
          }
        },
        tooltip: 'Create Character',
        child: const Icon(Icons.add),
      ),
    );
  }
}
