import 'package:flutter/material.dart';

class OperationsOrganizer extends StatefulWidget {
  final String? systemId;
  const OperationsOrganizer({super.key, this.systemId});

  @override
  State<OperationsOrganizer> createState() => _OperationsOrganizerState();
}

class _OperationsOrganizerState extends State<OperationsOrganizer> {
  // Local list for MVP. In production, this syncs with Supabase JSONB or a separate Tasks table.
  final List<Map<String, dynamic>> _tasks = [
    {"title": "Review hosting costs", "assignee": "Owner", "done": false},
  ];

  void _addTask() {
    setState(() {
      _tasks.add({"title": "New Operational Task", "assignee": "Unassigned", "done": false});
    });
    // TODO: Update Supabase `business_systems` tasks column
  }

  @override
  Widget build(BuildContext context) {
    if (widget.systemId == null) {
      return const Center(child: Text("Please select a System Template first."));
    }

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Card(
            child: CheckboxListTile(
              value: task['done'],
              onChanged: (bool? val) {
                setState(() => task['done'] = val);
              },
              title: Text(task['title']),
              subtitle: Text("Assigned to: ${task['assignee']}"),
              secondary: const Icon(Icons.drag_indicator),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}