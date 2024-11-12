class ShoppingList {
  int? id;
  String name;
  int userId;

  ShoppingList({
    this.id,
    required this.name,
    required this.userId,
  });

  // Convert ShoppingList object into a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
    };
  }

  // Convert map to ShoppingList object
  factory ShoppingList.fromMap(Map<String, dynamic> map) {
    return ShoppingList(
      id: map['id'],
      name: map['name'],
      userId: map['userId'],
    );
  }
}
