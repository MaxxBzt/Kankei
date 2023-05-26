
import 'dart:ui';

import 'package:flutter/material.dart';

class Event {
  final String name;
  final String description;
  final String category;
  final Color color_category;
  final DateTime date_of_event;

  Event({
    required this.name,
    required this.description,
    required this.category,
    required this.date_of_event,
    /*use the null-aware operator (!) to assert that the Color?
    value is not null and assign it to the non-nullable Color type*/
    Color? color_category,
  }) : color_category = color_category ?? Colors.blue;



  @override
  String toString() {
    return 'Event(name: $name, description: $description, category: $category, date: $date_of_event)';
  }

  Event copyWith({
    String? name,
    String? description,
    String? category,
    DateTime? date,
    Color? color_category,
  }) {
    return Event(
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      date_of_event: date ?? this.date_of_event,
      color_category : color_category ?? this.color_category,
    );
  }

}
