class UserModel {
  String name;
  String lastName;
  String? fullName;

  UserModel({
    required this.name,
    required this.lastName,
    this.fullName,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      lastName: map['lastName'] ?? '',
      fullName: map['full_name'] ?? '',
    );
  }
}
