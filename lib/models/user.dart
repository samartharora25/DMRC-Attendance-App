class User {
  final int? id;
  final String name;
  final String empId;
  final String faceImagePath;

  User({this.id, required this.name, required this.empId, required this.faceImagePath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'empId': empId,
      'faceImagePath': faceImagePath,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      empId: map['empId'],
      faceImagePath: map['faceImagePath'],
    );
  }
}

