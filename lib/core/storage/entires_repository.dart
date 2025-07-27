import 'package:shared_preferences/shared_preferences.dart';
import '../models/whats_new_entry.dart';

class EntriesRepository {
  static const _key = 'whats_new_entries';

  Future<List<WhatsNewEntry>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    return WhatsNewEntry.decodeList(raw);
  }

  Future<void> saveAll(List<WhatsNewEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, WhatsNewEntry.encodeList(entries));
  }

  Future<void> add(WhatsNewEntry entry) async {
    final all = await getAll();
    all.insert(0, entry); // newest first
    await saveAll(all);
  }

  Future<void> delete(WhatsNewEntry entry) async {
    final all = await getAll();
    all.removeWhere((e) => e.id == entry.id);
    await saveAll(all);
  }
}
