import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_new/core/storage/entires_repository.dart';
import '../../core/models/whats_new_entry.dart';

class AddWhatsNewScreen extends StatefulWidget {
  static const route = '/add';
  const AddWhatsNewScreen({super.key});

  @override
  State<AddWhatsNewScreen> createState() => _AddWhatsNewScreenState();
}

class _AddWhatsNewScreenState extends State<AddWhatsNewScreen> {
  final _controller = TextEditingController();
  final _repo = EntriesRepository();
  bool _saving = false;
  String _selectedTag = 'other';
  final List<String> _tags = ['learned', 'did', 'built', 'read', 'other'];

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please type something!')));
      return;
    }
    setState(() => _saving = true);
    final entry = WhatsNewEntry(
      id: const Uuid().v4(),
      date: DateTime.now(),
      text: text,
      tag: _selectedTag,
    );
    await _repo.add(entry);
    if (!mounted) return;
    Navigator.of(context).pop(); // back to list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add what's new")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What new thing did you do/learn today?",
              style: Theme.of(context).textTheme.titleLarge,
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 16),
            TextField(
              autofocus: true,
              controller: _controller,
              maxLines: 6,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Describe your new thing...",
              ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 24),
            Text(
              "Tag, so you can remember",
              style: Theme.of(context).textTheme.titleLarge,
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _tags.map((tag) {
                return ChoiceChip(
                  label: Text(tag),
                  selected: _selectedTag == tag,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedTag = tag;
                      });
                    }
                  },
                );
              }).toList(),
            ).animate().fadeIn(delay: 500.ms),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
                icon: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_rounded),
                label: const Text("Save"),
              ),
            ).animate().fadeIn(delay: 600.ms),
          ],
        ),
      ),
    );
  }
}
