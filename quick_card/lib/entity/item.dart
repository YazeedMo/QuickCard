class Item {
  int? id;
  String name;
  bool checkedOff;
  int shoppingListId;

  Item({
    this.id,
    required this.name,
    this.checkedOff = false,
    required this.shoppingListId,
  });

  // Convert Item object into a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'checkedOff': checkedOff ? 1 : 0, // Store boolean as integer (1 for true, 0 for false)
      'shoppingListId': shoppingListId,
    };
  }

  // Convert map to Item object
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      checkedOff: map['checkedOff'] == 1, // Convert integer back to boolean
      shoppingListId: map['shoppingListId'],
    );
  }
}
