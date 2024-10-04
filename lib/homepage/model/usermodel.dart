// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Usermodel {
  final String name;
  final String mobile;
  final String uid;
  final String email;
  final String address;
  Usermodel({
    required this.name,
    required this.mobile,
    required this.uid,
    required this.email,
    required this.address,
  });

  Usermodel copyWith({
    String? name,
    String? mobile,
    String? uid,
    String? email,
    String? address,
  }) {
    return Usermodel(
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'mobile': mobile,
      'uid': uid,
      'email': email,
      'address': address,
    };
  }

  factory Usermodel.fromMap(Map<String, dynamic> map) {
    return Usermodel(
      name: map['name'] as String,
      mobile: map['mobile'] as String,
      uid: map['uid'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Usermodel.fromJson(String source) =>
      Usermodel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Usermodel(name: $name, mobile: $mobile, uid: $uid, email: $email, address: $address)';
  }

  @override
  bool operator ==(covariant Usermodel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.mobile == mobile &&
        other.uid == uid &&
        other.email == email &&
        other.address == address;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        mobile.hashCode ^
        uid.hashCode ^
        email.hashCode ^
        address.hashCode;
  }
}
