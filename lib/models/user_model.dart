class UserModel {
  final int? id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String createdAt;
  final String? token;
  final String? password;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.createdAt,
    this.token,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      fullName: '${json['first_name']} ${json['last_name']}',
      email: json['email'] as String,
      phoneNumber: json['phone'] as String,
      address: json['address'] as String,
      createdAt: json['created_at'] as String,
      token: json['token'] as String?,
      password: json['password'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': fullName.split(' ').first,
      'last_name': fullName.split(' ').length > 1
          ? fullName.split(' ').sublist(1).join(' ')
          : '',
      'email': email,
      'phone': phoneNumber,
      'address': address,
      'created_at': createdAt,
      'token': token,
      'password': password
    };
  }
}
