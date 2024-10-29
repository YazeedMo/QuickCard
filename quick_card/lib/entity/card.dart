class Card {
  int? id;
  String name;
  String data;
  String barcodeFormat;
  String svg;
  String? imagePath;
  int folderId;

  Card({
    this.id,
    required this.name,
    required this.data,
    required this.barcodeFormat,
    required this.svg,
    this.imagePath,
    required this.folderId,
  });

  // Convert Card object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'data': data,
      'barcodeFormat': barcodeFormat,
      'svg': svg,
      'imagePath': imagePath,
      'folderId': folderId,
    };
  }

  // Create a Card object from a map
  factory Card.fromMap(Map<String, dynamic> map) {
    return Card(
      id: map['id'],
      name: map['name'],
      data: map['data'],
      barcodeFormat: map['barcodeFormat'],
      svg: map['svg'],
      imagePath: map['imagePath'],
      folderId: map['folderId'],
    );
  }
}
