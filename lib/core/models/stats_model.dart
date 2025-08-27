import '../models/whats_new_entry.dart';

class Stats {
  final int totalEntries;
  final int currentStreak;
  final int longestStreak;
  final Map<String, int> weeklyEntries; // e.g., {"Mon": 2, "Tue": 3}
  final Map<String, int> monthlyEntries; // e.g., {"Jan": 5, "Feb": 7}

  Stats({
    required this.totalEntries,
    required this.currentStreak,
    required this.longestStreak,
    required this.weeklyEntries,
    required this.monthlyEntries,
  });
}

class StatsCalculator {
  static Stats calculate(List<WhatsNewEntry> entries) {
    if (entries.isEmpty) {
      return Stats(
        totalEntries: 0,
        currentStreak: 0,
        longestStreak: 0,
        weeklyEntries: {},
        monthlyEntries: {},
      );
    }

    // Use a set to store unique dates, then sort them descending
    final uniqueDates = entries
        .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
        .toSet()
        .toList();
    uniqueDates.sort((a, b) => b.compareTo(a));

    int longestStreak = 0;
    int currentStreak = 0;
    if (uniqueDates.isNotEmpty) {
      int streak = 1;
      for (int i = 0; i < uniqueDates.length - 1; i++) {
        if (uniqueDates[i].difference(uniqueDates[i + 1]).inDays == 1) {
          streak++;
        } else {
          if (streak > longestStreak) {
            longestStreak = streak;
          }
          streak = 1;
        }
      }
      if (streak > longestStreak) {
        longestStreak = streak;
      }

      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      final yesterdayDate = todayDate.subtract(const Duration(days: 1));

      if (uniqueDates.first.isAtSameMomentAs(todayDate) ||
          uniqueDates.first.isAtSameMomentAs(yesterdayDate)) {
        currentStreak = 1;
        for (int i = 0; i < uniqueDates.length - 1; i++) {
          if (uniqueDates[i].difference(uniqueDates[i + 1]).inDays == 1) {
            currentStreak++;
          } else {
            break;
          }
        }
      }
    }

    // Weekly entries (Mon-Sun)
    final Map<String, int> weekly = {};
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    for (var e in entries) {
      if (e.date.isAfter(startOfWeek)) {
        final dayName = _weekdayName(e.date.weekday);
        weekly[dayName] = (weekly[dayName] ?? 0) + 1;
      }
    }

    // Monthly entries
    final Map<String, int> monthly = {};
    for (var e in entries) {
      final monthName = _monthName(e.date.month);
      monthly[monthName] = (monthly[monthName] ?? 0) + 1;
    }

    return Stats(
      totalEntries: entries.length,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      weeklyEntries: weekly,
      monthlyEntries: monthly,
    );
  }

  static String _weekdayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  static String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
