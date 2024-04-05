import 'package:equatable/equatable.dart';

import 'contants.dart';

class Contact extends Equatable {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String? img;

  const Contact({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.img,
  });

  Contact copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? img,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      img: img ?? this.img,
    );
  }

  factory Contact.fromMap(Map map) {
    return Contact(
      id: map[idColumn],
      name: map[nameColumn],
      email: map[emailColumn],
      phone: map[phoneColumn],
      img: map[imgColumn],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      idColumn: id,
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    return map;
  }

  @override
  String toString() {
    return 'Contact(id: $id, nama: $name, emal: $email, phone: $phone, img: $img)';
  }

  @override
  List<Object?> get props => [id, name, email, phone, img];
}
