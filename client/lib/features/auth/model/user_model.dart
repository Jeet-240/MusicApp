import 'dart:convert';

class UserModel{
  final String name;
  final String email;
  final String id;

  //<editor-fold desc="Data Methods">
  const UserModel({
    required this.name,
    required this.email,
    required this.id,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is UserModel &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              email == other.email &&
              id == other.id
          );


  @override
  int get hashCode =>
      name.hashCode ^
      email.hashCode ^
      id.hashCode;




  UserModel copyWith({
    String? name,
    String? email,
    String? id,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'id': id,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      id: map['id'] ?? '',
    );
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'UserModel{name: $name, email: $email, id: $id}';
  }


}