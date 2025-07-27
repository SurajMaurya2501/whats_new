import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:whats_new/core/constants/app_typography.dart';
import 'package:whats_new/core/models/stats_model.dart';
import 'package:whats_new/core/storage/entires_repository.dart';
import 'package:whats_new/widgets/empty_.dart';
import '../../core/models/whats_new_entry.dart';

class WhatsNewScreen extends StatefulWidget {
  static const route = '/list';
  const WhatsNewScreen({super.key});

  @override
  State<WhatsNewScreen> createState() => _WhatsNewScreenState();
}

class _WhatsNewScreenState extends State<WhatsNewScreen> {
  final _repo = EntriesRepository();
  late Future<List<WhatsNewEntry>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.getAll();
  }

  Future<void> _reload() async {
    final data = await _repo.getAll();
    setState(() {
      _future = Future.value(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat.yMMMMd().format(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: const Text("What's New")),
      body: FutureBuilder<List<WhatsNewEntry>>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final entries = snap.data!;
          final stats = StatsCalculator.calculate(entries);
          if (entries.isEmpty) {
            return EmptyState(
              title: "Nothing yet!",
              message:
                  "Add a few lines about what you learned or did today.\nStart with your first 'what's new'.",
              action: () => Navigator.of(
                context,
              ).pushNamed('/add').then((_) => _reload()),
            );
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: Column(
              children: [
                _buildStatsCard(stats),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(12),
                    itemCount: entries.length,
                    itemBuilder: (context, i) {
                      //if (i == 0) {
                      //  return Padding(
                      //    padding: const EdgeInsets.only(bottom: 12),
                      //    child: Text(
                      //      "Today: $today\nTotal: ${entries.length} items",
                      //      style: Theme.of(context).textTheme.bodySmall,
                      //    ),
                      //  );
                      //}
                      final item = entries[i]; //
                      final dateStr = DateFormat.yMMMd().format(item.date);
                      final tag = item.tag == "" ? 'other' : item.tag;
                      return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text((i + 1).toString()),
                              ),
                              title: Text(
                                item.text,
                                style: AppTypography.bodyText,
                                overflow: TextOverflow.visible,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  _repo.delete(item).then((value) {
                                    _reload();
                                  });
                                },
                                icon: Image.asset(
                                  "assets/delete.png",
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(dateStr),
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: getColor(tag),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      tag,
                                      style: GoogleFonts.rokkitt(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .animate(delay: (i * 100).ms)
                          .fadeIn(begin: 0.5, delay: (i * 100).ms)
                        ..slide(
                          begin: Offset(0, 0.3),
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          end: Offset.zero,
                        );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/add');
          _reload();
        },
        icon: const Icon(Icons.add),
        label: const Text("Add what's new"),
      ),
    );
  }

  Widget _buildStatsCard(Stats stats) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("🔥${stats.currentStreak}"),
            ),
          ),
          // Text("🏆${stats.longestStreak}"),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Weekly ${stats.weeklyEntries.values.fold(0, (a, b) => a + b)} days",
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Monthly ${stats.monthlyEntries.values.fold(0, (a, b) => a + b)} days",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color getColor(String tag) {
    List<Color> tagColors = [
      const Color.fromARGB(255, 240, 196, 138),
      const Color.fromARGB(255, 165, 198, 255),
      const Color.fromARGB(255, 135, 244, 191),
      const Color.fromARGB(255, 148, 245, 235),
      const Color.fromARGB(255, 239, 161, 187),
    ];
    switch (tag) {
      case 'learned':
        return tagColors[0];
      case 'built':
        return tagColors[1];
      case 'read':
        return tagColors[2];
      case 'did':
        return tagColors[3];
      case 'other':
        return tagColors[4];
      default:
        return tagColors[0];
    }
  }
}
