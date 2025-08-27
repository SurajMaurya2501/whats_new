import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whats_new/core/constants/app_typography.dart';
import 'package:whats_new/core/models/stats_model.dart';
import 'package:whats_new/core/providers/theme_provider.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("What's New"),
        actions: [
          Switch(
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (_) {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
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
                  child: AnimationLimiter(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(12),
                      itemCount: entries.length,
                      itemBuilder: (context, i) {
                        final item = entries[i];
                        final dateStr = DateFormat.yMMMd().format(item.date);
                        final tag = item.tag == "" ? 'other' : item.tag;
                        return AnimationConfiguration.staggeredList(
                          position: i,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.pinkAccent,
                                      Colors.blueAccent,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.pink.withAlpha(150),
                                      blurRadius: 1,
                                      spreadRadius: 1,
                                      offset: Offset(-1, -1),
                                    ),
                                    BoxShadow(
                                      color: Colors.blue.withAlpha(150),
                                      blurRadius: 1,
                                      spreadRadius: 1,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                                child: Card(
                                  margin: const EdgeInsets.all(2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
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
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Text(dateStr),
                                          const SizedBox(width: 10),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: getColor(tag),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 2,
                                            ),
                                            child: Text(
                                              tag,
                                              style: GoogleFonts.rokkitt(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      '🔥',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text('${stats.currentStreak} Day Streak'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      '🏆',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text('${stats.longestStreak} Day Record'),
                  ],
                ),
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
