import 'package:flutter/material.dart';

class CharacterListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> characters;

  const CharacterListWidget({
    required this.characters,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return CharacterItem(character: character);
      },
    );
  }
}

class CharacterItem extends StatefulWidget {
  final Map<String, dynamic> character;

  const CharacterItem({
    required this.character,
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
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          ListTile(
            title: Text(
              character['name'].toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
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
                  _buildInfoRow('Constitution',
                   character['constitution'].toString(),),
                  _buildInfoRow('Intelligence', 
                  character['intelligence'].toString(),),
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
