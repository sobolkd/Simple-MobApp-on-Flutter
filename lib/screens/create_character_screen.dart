import 'package:flutter/material.dart';
import 'package:my_project/widgets/button.dart';
import 'package:my_project/widgets/dropdown_field.dart';

class CreateCharacterScreen extends StatelessWidget {
  const CreateCharacterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Character')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Character Name', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter character name',
              ),
            ),
            const SizedBox(height: 16),
           const DropdownField(
              label: 'Class',
              options: ['Ranger', 'Bard', 'Rogue', 'Sorcerer', 'Warlock', 
              'Wizard', 'Cleric', 'Druid', 'Paladin', 'Barbarian', 'Fighter',
               'Monk',], 
              hintText: 'Select character class',
            ),
            const SizedBox(height: 16),
          const  DropdownField(
              label: 'Race',
              options: ['Aasimar', 'Dragonborn', 'Dwarf', 'Elf', 'Gnome', 
              'Goliath', 'Halfling', 'Human', 'Orc', 'Tiefling',], 
              hintText: 'Select character race',
            ),
            const SizedBox(height: 16),
            Center(
              child: CustomButton(
                text: 'Create Character',
                onPressed: () {
                  // Logic to save character goes here
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
