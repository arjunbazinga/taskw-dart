import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:taskc/json.dart';

part 'task.g.dart';

final coreAttributes = [
  'id',
  'status',
  'uuid',
  'entry',
  'description',
  'start',
  'end',
  'due',
  'until',
  'wait',
  'modified',
  'scheduled',
  'recur',
  'mask',
  'imask',
  'parent',
  'project',
  'priority',
  'depends',
  'tags',
  'annotations',
  'urgency',
];

abstract class Task implements Built<Task, TaskBuilder> {
  factory Task([void Function(TaskBuilder) updates]) = _$Task;
  Task._();

  static Task fromJson(Map json) {
    var udas = Map.of(json)
      ..removeWhere((key, _) => coreAttributes.contains(key));
    var result = Map.of(json)
      ..removeWhere((key, _) => !coreAttributes.contains(key))
      ..['udas'] = (udas.isEmpty) ? null : jsonEncode(udas);
    return serializers.deserializeWith(Task.serializer, result)!;
  }

  Map<String, dynamic> toJson() {
    var result = serializers.serializeWith(Task.serializer, this)!
        as Map<String, dynamic>;

    if (result['udas'] != null) {
      var udas = Map<String, dynamic>.of(json.decode(result['udas']));
      result
        ..remove('udas')
        ..addAll(udas);
    }

    return result;
  }

  int? get id;
  String get status;
  String get uuid;
  DateTime get entry;
  String get description;
  DateTime? get start;
  DateTime? get end;
  DateTime? get due;
  DateTime? get until;
  DateTime? get wait;
  DateTime? get modified;
  DateTime? get scheduled;
  String? get recur;
  String? get mask;
  int? get imask;
  String? get parent;
  String? get project;
  String? get priority;
  String? get depends;
  BuiltList<String>? get tags;
  BuiltList<Annotation>? get annotations;
  String? get udas;
  double? get urgency;

  static Serializer<Task> get serializer => _$taskSerializer;
}
