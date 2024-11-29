import 'package:flutter/material.dart';
import 'package:my_project/services/spell_repository.dart';

class SpellProvider with ChangeNotifier {
  final SpellRepository _spellRepository = SpellRepository();
  List<Map<String, String>> _spells = [];
  bool _isLoading = true;
  String _errorMessage = '';

  List<Map<String, String>> get spells => _spells;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchSpells() async {
    try {
      _isLoading = true;
      notifyListeners();
      _spells = await _spellRepository.fetchSpells();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> fetchSpellDetails(String url) async {
    return await _spellRepository.fetchSpellDetails(url);
  }
}
