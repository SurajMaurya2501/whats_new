import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

class WhatsNewEntry {
  final String id;
  final DateTime date;
  final String text;
  final String tag;
  // final Color tagColor;

  WhatsNewEntry({
    required this.id,
    required this.date,
    required this.text,
    required this.tag,
    // required this.tagColor,
  });

  factory WhatsNewEntry.fromJson(Map<String, dynamic> json) => WhatsNewEntry(
    id: json['id'] as String,
    date: DateTime.parse(json['date'] as String),
    text: json['text'] as String,
    tag: (json['tag'] ?? "") as String,
    // tagColor: (json['tagColor'] ?? Colors.orangeAccent) as Color,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'text': text,
    'tag': tag,
    // "tagColor": tagColor,
  };

  static List<WhatsNewEntry> decodeList(String raw) {
    final List list = jsonDecode(raw) as List;
    return list.map((e) => WhatsNewEntry.fromJson(e)).toList();
  }

  static String encodeList(List<WhatsNewEntry> entries) {
    return jsonEncode(entries.map((e) => e.toJson()).toList());
  }
}
