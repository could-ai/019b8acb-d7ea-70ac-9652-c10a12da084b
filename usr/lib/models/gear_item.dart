class GearItem {
  final String id;
  final String name;
  final String category;
  bool isChecked;
  String? assignedTo; // 'Me', 'Partner', or null (unassigned)

  GearItem({
    required this.id,
    required this.name,
    required this.category,
    this.isChecked = false,
    this.assignedTo,
  });
}
