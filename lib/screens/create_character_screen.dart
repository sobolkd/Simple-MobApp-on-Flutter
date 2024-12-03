import 'package:flutter/material.dart';
import 'package:my_project/database_helper.dart';
import 'package:my_project/widgets/button.dart';
import 'package:my_project/widgets/dropdown_field.dart';

class CreateCharacterScreen extends StatefulWidget {
  const CreateCharacterScreen({super.key});

  @override
  CreateCharacterScreenState createState() => CreateCharacterScreenState();
}

class CreateCharacterScreenState extends State<CreateCharacterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController strengthController = TextEditingController();
  final TextEditingController dexterityController = TextEditingController();
  final TextEditingController constitutionController = TextEditingController();
  final TextEditingController intelligenceController = TextEditingController();
  final TextEditingController wisdomController = TextEditingController();
  final TextEditingController charismaController = TextEditingController();

  String? selectedClass;
  String? selectedRace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Character')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Character Name', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter character name',
              ),
            ),
            const SizedBox(height: 16),
            DropdownField(
              label: 'Class',
              options: [
                'Ranger', 'Bard', 'Rogue', 'Sorcerer', 'Warlock', 'Wizard',
                'Cleric', 'Druid', 'Paladin', 'Barbarian', 'Fighter', 'Monk',
              ],
              hintText: 'Select character class',
              onChanged: (value) {
                setState(() {
                  selectedClass = value;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownField(
              label: 'Race',
              options: [
                'Aasimar', 'Dragonborn', 'Dwarf', 'Elf', 'Gnome', 'Goliath',
                'Halfling', 'Human', 'Orc', 'Tiefling',
              ],
              hintText: 'Select character race',
              onChanged: (value) {
                setState(() {
                  selectedRace = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Characteristics inputs
            const Text('Strength (1-20)', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            _buildCharacteristicField(strengthController),
            const SizedBox(height: 16),
            const Text('Dexterity (1-20)', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            _buildCharacteristicField(dexterityController),
            const SizedBox(height: 16),
            const Text('Constitution (1-20)', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            _buildCharacteristicField(constitutionController),
            const SizedBox(height: 16),
            const Text('Intelligence (1-20)', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            _buildCharacteristicField(intelligenceController),
            const SizedBox(height: 16),
            const Text('Wisdom (1-20)', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            _buildCharacteristicField(wisdomController),
            const SizedBox(height: 16),
            const Text('Charisma (1-20)', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            _buildCharacteristicField(charismaController),
            const SizedBox(height: 16),
            Center(
              child: CustomButton(
                text: 'Create Character',
                onPressed: () {
                  if (nameController.text.isEmpty || selectedClass == null || 
                  selectedRace == null) {
                    showSnackBar('Please fill all fields');
                  } else {
                    if (_validateCharacteristics()) {
                      saveCharacter();
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacteristicField(TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter a value between 1 and 20',
      ),
      onChanged: (value) {
        if (int.tryParse(value) != null && (int.parse(value) < 1 ||
         int.parse(value) > 20)) {
          controller.text = '1'; 
        }
      },
    );
  }

  bool _validateCharacteristics() {
    final characteristics = [
      strengthController.text,
      dexterityController.text,
      constitutionController.text,
      intelligenceController.text,
      wisdomController.text,
      charismaController.text,
    ];

    for (var characteristic in characteristics) {
      final value = int.tryParse(characteristic);
      if (value == null || value < 1 || value > 20) {
        showSnackBar('All characteristics must be between 1 and 20');
        return false;
      }
    }

    return true;
  }

  Future<void> saveCharacter() async {
  final character = {
    'name': nameController.text,
    'class': selectedClass!,
    'race': selectedRace!,
    'strength': int.parse(strengthController.text),
    'dexterity': int.parse(dexterityController.text),
    'constitution': int.parse(constitutionController.text),
    'intelligence': int.parse(intelligenceController.text),
    'wisdom': int.parse(wisdomController.text),
    'charisma': int.parse(charismaController.text),
  };

  try {
    final databaseHelper = DatabaseHelper();
    await databaseHelper.insertCharacter(character);

    final String confirmationMessage = 'Character Created Successfully:\n'
        'Name: ${character['name']}\n'
        'Class: ${character['class']}\n'
        'Race: ${character['race']}\n'
        'Strength: ${character['strength']}\n'
        'Dexterity: ${character['dexterity']}\n'
        'Constitution: ${character['constitution']}\n'
        'Intelligence: ${character['intelligence']}\n'
        'Wisdom: ${character['wisdom']}\n'
        'Charisma: ${character['charisma']}';

    showSnackBar(confirmationMessage);

    if (mounted) {
      Navigator.pop(context, true); // Повертаємось назад з результатом
    }
  } catch (e) {
    // ignore: avoid_print
    print('Error while saving character: $e');
    
    showSnackBar('Error: $e');
  }
}


  void showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
}
