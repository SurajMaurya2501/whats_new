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

    // Sort by date descending
    entries.sort((a, b) => b.date.compareTo(a.date));

    // Streak calculation
    int currentStreak = 0;
    int longestStreak = 0;
    DateTime? prevDay;

    for (var e in entries) {
      final day = DateTime(e.date.year, e.date.month, e.date.day);
      if (prevDay == null) {
        currentStreak = 1;
      } else {
        final diff = prevDay.difference(day).inDays;
        if (diff == 1) {
          currentStreak++;
        } else if (diff > 1) {
          longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;
          currentStreak = 1; // reset
        }
      }
      prevDay = day;
    }
    longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;

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
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
