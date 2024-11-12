class Card {
  int? id;
  String name;
  String data;
  String format;
  String svg;
  String? imagePath;
  bool favourite;
  int userId;

  Card({
    this.id,
    required this.name,
    required this.data,
    required this.format,
    required this.svg,
    this.imagePath,
    this.favourite = false,
    required this.userId,
  });

  // Convert Card object into a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'data': data,
      'format': format,
      'svg': svg,
      'imagePath': imagePath,
      'favourite': favourite ? 1 : 0,
      'userId': userId
    };
  }

  // Create map to Card object
  factory Card.fromMap(Map<String, dynamic> map) {
    return Card(
      id: map['id'],
      name: map['name'],
      data: map['data'],
      format: map['format'],
      svg: map['svg'],
      imagePath: map['imagePath'],
      favourite: map['favourite'] == 1,
      userId: map['userId']
    );
  }
}
