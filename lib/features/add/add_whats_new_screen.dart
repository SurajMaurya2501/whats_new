import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String tag = 'other';
  List<String> tags = ['learned', 'did', 'built', 'read', 'other'];

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
      tag: tag,
      
    );
    await _repo.add(entry);
    if (!mounted) return;
    Navigator.of(context).pop(); // back to list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add what's new")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What new thing did you do/learn today?",
              style: GoogleFonts.quicksand(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              autofocus: true,
              controller: _controller,
              maxLines: 6,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Describe you new thing...",
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Tag, so you can remember",
              style: GoogleFonts.quicksand(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                  tags.length,
                  (index) => ChoiceChip(
                    onSelected: (value) {
                      setState(() {
                        tag = tags[index];
                      });
                    },
                    label: Text(tags[index]),
                    selected: tag == tags[index],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
