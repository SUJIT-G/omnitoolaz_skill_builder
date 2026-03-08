import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameManager extends ChangeNotifier {
  final SharedPreferences _prefs;
  int _xp = 0; int _streak = 1; int _level = 1; List<String> _unlockedBadges = [];

  GameManager(this._prefs) { _loadData(); }
  int get xp => _xp; int get streak => _streak; int get level => _level; List<String> get badges => _unlockedBadges;

  void _loadData() {
    _xp = _prefs.getInt('xp') ?? 0; _streak = _prefs.getInt('streak') ?? 1;
    _level = _prefs.getInt('level') ?? 1; _unlockedBadges = _prefs.getStringList('badges') ?? ['Beginner'];
    notifyListeners();
  }

  void addXP(int amount) {
    _xp += amount; _level = (_xp / 100).floor() + 1;
    _prefs.setInt('xp', _xp); _prefs.setInt('level', _level);
    if (_xp >= 100 && !_unlockedBadges.contains('Knowledge Ninja')) _unlockedBadges.add('Knowledge Ninja');
    _prefs.setStringList('badges', _unlockedBadges); notifyListeners();
  }
}
