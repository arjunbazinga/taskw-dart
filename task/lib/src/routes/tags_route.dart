import 'package:flutter/material.dart';

import 'package:built_collection/built_collection.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:taskw/taskw.dart';

import 'package:task/task.dart';

class TagsRoute extends StatefulWidget {
  const TagsRoute({required this.value, required this.callback});

  final ListBuilder<String>? value;
  final void Function(ListBuilder<String>?) callback;

  @override
  TagsRouteState createState() => TagsRouteState();
}

class TagsRouteState extends State<TagsRoute> {
  Map<String, int>? _globalTags;
  ListBuilder<String>? draftTags;

  void _addTag(String tag) {
    if (draftTags == null) {
      draftTags = ListBuilder([tag]);
    } else {
      draftTags!.add(tag);
    }
    widget.callback(draftTags);
    setState(() {});
  }

  void _removeTag(String tag) {
    draftTags!.remove(tag);
    widget.callback((draftTags!.isEmpty) ? null : draftTags);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    draftTags = widget.value;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initialize();
  }

  Future<void> _initialize() async {
    _globalTags = StorageWidget.of(context).globalTags
      ..putIfAbsent(
        'next',
        () => 0,
      );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tags'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4),
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (draftTags != null)
                  for (var tag in draftTags!.build())
                    FilterChip(
                      onSelected: (_) => _removeTag(tag),
                      label: Text(
                        '+$tag',
                        style: GoogleFonts.firaMono(),
                      ),
                    ),
                Divider(),
                if (_globalTags != null)
                  for (var tag in _globalTags!.entries.where((tag) =>
                      !(draftTags?.build().contains(tag.key) ?? false)))
                    FilterChip(
                      onSelected: (_) => _addTag(tag.key),
                      label: Text(
                        '-${tag.key}',
                        style: GoogleFonts.firaMono(),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var controller = TextEditingController();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              scrollable: true,
              title: Text('Add tag'),
              content: TextField(
                autofocus: true,
                controller: controller,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    try {
                      validateTaskTags(controller.text);
                      _addTag(controller.text);
                      Navigator.of(context).pop();
                    } on FormatException catch (e, trace) {
                      showExceptionDialog(
                        context: context,
                        e: e,
                        trace: trace,
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
