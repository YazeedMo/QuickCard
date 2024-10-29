class Folder {

  int? id;
  String name;
  String? description;
  String? imagePath;
  int userId;

  Folder({
    this.id,
    required this.name,
    this.description,
    this.imagePath,
    required this.userId,
  });

  // Convert Folder object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'userId': userId,
    };
  }

  // Create a Folder object from a map
  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imagePath: map['imagePath'],
      userId: map['userId'],
    );
  }

}