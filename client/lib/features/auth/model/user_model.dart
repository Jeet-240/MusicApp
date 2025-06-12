class UserModel{
  final String name;
  final String email;
  final String id;
  final String token;

   UserModel({
    required this.name,
    required this.email,
    required this.id,
    required this.token,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is UserModel &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              email == other.email &&
              id == other.id &&
              token == other.token
          );


  @override
  int get hashCode =>
      name.hashCode ^
      email.hashCode ^
      id.hashCode ^
      token.hashCode;



  UserModel copyWith({
    String? name,
    String? email,
    String? id,
    String? token,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      token: token ?? this.token,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'id': id,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      id: map['id'] ?? '',
      token: map['token'] ?? '',
    );
  }

  @override
  String toString() {
    return 'UserModel{name: $name, email: $email, id: $id, token: $token}';
  }


//</editor-fold>

  //<editor-fold desc="Data Methods">


}