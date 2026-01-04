import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gear_provider.dart';
import '../models/gear_item.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GearProvider>(context);
    final items = provider.items;

    // Group items by category
    final Map<String, List<GearItem>> groupedItems = {};
    for (var item in items) {
      if (!groupedItems.containsKey(item.category)) {
        groupedItems[item.category] = [];
      }
      groupedItems[item.category]!.add(item);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expedition Checklist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Collaboration link copied! (Mock)')),
              );
            },
          ),
        ],
      ),
      body: items.isEmpty
          ? const Center(child: Text('No items found. Upload a PDF first.'))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: groupedItems.keys.length,
              itemBuilder: (context, index) {
                final category = groupedItems.keys.elementAt(index);
                final categoryItems = groupedItems[category]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Text(
                        category.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    ...categoryItems.map((item) => _GearItemTile(item: item)),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Add Item'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _GearItemTile extends StatelessWidget {
  final GearItem item;

  const _GearItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GearProvider>(context, listen: false);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Checkbox(
        value: item.isChecked,
        activeColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        onChanged: (val) => provider.toggleItemCheck(item.id),
      ),
      title: Text(
        item.name,
        style: TextStyle(
          decoration: item.isChecked ? TextDecoration.lineThrough : null,
          color: item.isChecked ? Colors.grey : Colors.black,
        ),
      ),
      trailing: _AssignmentBadge(item: item),
      onTap: () => provider.toggleItemCheck(item.id),
    );
  }
}

class _AssignmentBadge extends StatelessWidget {
  final GearItem item;

  const _AssignmentBadge({required this.item});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GearProvider>(context, listen: false);
    
    // Cycle assignment: null -> Me -> Partner -> null
    void cycleAssignment() {
      if (item.assignedTo == null) {
        provider.assignItem(item.id, 'Me');
      } else if (item.assignedTo == 'Me') {
        provider.assignItem(item.id, 'Partner');
      } else {
        provider.assignItem(item.id, null);
      }
    }

    Color badgeColor;
    String text;
    
    if (item.assignedTo == 'Me') {
      badgeColor = Colors.blue[100]!;
      text = 'ME';
    } else if (item.assignedTo == 'Partner') {
      badgeColor = Colors.green[100]!;
      text = 'PARTNER';
    } else {
      return IconButton(
        icon: const Icon(Icons.person_outline, color: Colors.grey),
        onPressed: cycleAssignment,
      );
    }

    return GestureDetector(
      onTap: cycleAssignment,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
