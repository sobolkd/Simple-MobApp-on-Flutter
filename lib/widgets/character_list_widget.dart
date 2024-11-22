import 'package:flutter/material.dart';
import 'package:my_project/database_helper.dart';

class CharacterListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> characters;
  final VoidCallback onDelete;

  const CharacterListWidget({
    required this.characters,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return CharacterItem(character: character, onDelete: onDelete);
      },
    );
  }
}

class CharacterItem extends StatefulWidget {
  final Map<String, dynamic> character;
  final VoidCallback onDelete;

  const CharacterItem({
    required this.character,
    required this.onDelete,
    super.key,
  });

  @override
  State<CharacterItem> createState() => _CharacterItemState();
}

class _CharacterItemState extends State<CharacterItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final character = widget.character;

    return Card(
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.grey[400]!,
          // ignore: avoid_redundant_argument_values
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          ListTile(
            title: Text(
              character['name'].toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, color:
               Colors.black,),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more, 
                  color: Colors.black,),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                   final bool confirmDelete = await
                    _showDeleteConfirmation(context);
                    if (confirmDelete) {
                      final dbHelper = DatabaseHelper();
       await dbHelper.deleteCharacter(int.parse(character['id'].toString()));
                      widget.onDelete();

                      if (mounted) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Character deleted')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Class', character['class'].toString()),
                  _buildInfoRow('Race', character['race'].toString()),
                  _buildInfoRow('Strength', character['strength'].toString()),
                  _buildInfoRow('Dexterity', character['dexterity'].toString()),
       _buildInfoRow('Constitution', character['constitution'].toString()),
         _buildInfoRow('Intelligence', character['intelligence'].toString()),
                  _buildInfoRow('Wisdom', character['wisdom'].toString()),
                  _buildInfoRow('Charisma', character['charisma'].toString()),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
       style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }


  Future<bool> _showDeleteConfirmation(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Delete Character',
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          'Are you sure you want to delete this character?',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );

  return result ?? false;
}
} 
