import 'package:flutter/material.dart';

class ExpandableSections extends StatefulWidget {
  const ExpandableSections({Key? key}) : super(key: key);

  @override
  State<ExpandableSections> createState() => _ExpandableSectionsState();
}

class _ExpandableSectionsState extends State<ExpandableSections> {
  bool isCDExpanded = false;
  bool isNotesExpanded = false;
  bool isConversationExpanded = false;

  Widget buildSection({
    required bool isExpanded,
    required Function(bool) onExpansionChanged,
    required IconData icon,
    required String title,
    required Widget? child,
  }) {
    return ExpansionTile(
      initiallyExpanded: isExpanded,
      onExpansionChanged: onExpansionChanged,
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(
          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          size: 20,
          color: Colors.black,
        ),
      ),
      children: child != null ? [child] : [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          buildSection(
            isExpanded: isCDExpanded,
            onExpansionChanged: (value) => setState(() => isCDExpanded = value),
            icon: Icons.folder_copy_outlined,
            title: "CDs",
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text("CD content goes here..."),
            ),
          ),
          const Divider(height: 0),
          buildSection(
            isExpanded: isNotesExpanded,
            onExpansionChanged: (value) => setState(() => isNotesExpanded = value),
            icon: Icons.edit_note_outlined,
            title: "Notes",
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text("Notes content goes here..."),
            ),
          ),
          const Divider(height: 0),
          buildSection(
            isExpanded: isConversationExpanded,
            onExpansionChanged: (value) => setState(() => isConversationExpanded = value),
            icon: Icons.chat_outlined,
            title: "Conversation",
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text("Conversation content or widget goes here..."),
            ),
          ),
        ],
      ),
    );
  }
}
