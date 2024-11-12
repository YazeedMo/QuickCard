class Folder {

  int? id;
  String name;
  String? imagePath;
  int userId;

  Folder({
    this.id,
    required this.name,
    this.imagePath,
    required this.userId,
  });

  // Convert Folder object into a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'userId': userId,
    };
  }

  // Convert map to Folder object
  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id'],
      name: map['name'],
      imagePath: map['imagePath'],
      userId: map['userId'],
    );
  }

}