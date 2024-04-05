part of 'contact_cubit.dart';

class ContactState extends Equatable {
  final Name name;
  final Email email;
  final Phone phone;
  final int? id;
  final String? img;
  final bool isEdited;
  final bool isValid;
  final bool isNew;

  const ContactState({
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.phone = const Phone.pure(),
    this.id,
    this.img,
    this.isEdited = false,
    this.isValid = false,
    this.isNew = true,
  });

  ContactState copyWith({
    Name? name,
    Email? email,
    Phone? phone,
    int? id,
    String? img,
    bool? isEdited,
    bool? isValid,
    bool? isNew,
  }) {
    return ContactState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      id: id ?? this.id,
      img: img ?? this.img,
      isEdited: isEdited ?? this.isEdited,
      isValid: isValid ?? this.isValid,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  List<Object?> get props =>
      [name, email, phone, img, isEdited, isValid, isNew];
}
