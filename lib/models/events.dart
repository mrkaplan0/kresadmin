// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uuid/uuid.dart';

class Event {
  final String eventsID;
  final String title;
  final DateTime eventDate;
  final String eventInfo;

  Event({
    required this.eventsID,
    required this.title,
    required this.eventDate,
    this.eventInfo = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'eventsID': eventsID,
      'title': title,
      'eventDate': eventDate.millisecondsSinceEpoch,
      'eventInfo': eventInfo,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      eventsID: (map['eventsID'] ?? '') as String,
      title: (map['title'] ?? '') as String,
      eventDate:
          DateTime.fromMillisecondsSinceEpoch((map['eventDate'] ?? 0) as int),
      eventInfo: (map['eventInfo'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Event(eventsID: $eventsID, title: $title, eventDate: $eventDate, eventInfo: $eventInfo)';
  }

  @override
  bool operator ==(covariant Event other) {
    if (identical(this, other)) return true;

    return other.eventsID == eventsID &&
        other.title == title &&
        other.eventDate == eventDate &&
        other.eventInfo == eventInfo;
  }
}
