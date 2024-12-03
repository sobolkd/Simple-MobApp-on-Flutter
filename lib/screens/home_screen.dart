import 'package:flutter/material.dart';
import 'package:my_project/database_helper.dart';
import 'package:my_project/network_utils.dart';
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

  Future<void> _handleCreateCharacter() async {
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      _showNoConnectionDialog();
      return;
    }

    final result = await Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => const CreateCharacterScreen(),
      ),
    );
    if (result == true) {
      _loadCharacters();
    }
  }

  Future<void> _showNoConnectionDialog() async {
    return showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('No Internet Connection', style: TextStyle(color:
        Colors.black,),),
        content: const Text('Please check your internet connection.', style: 
        TextStyle(color: Colors.black,),),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
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
        onPressed: _handleCreateCharacter,
        tooltip: 'Create Character',
        child: const Icon(Icons.add),
      ),
    );
  }
}
