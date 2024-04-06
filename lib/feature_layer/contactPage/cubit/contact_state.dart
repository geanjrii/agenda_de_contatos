part of 'contact_cubit.dart';

class ContactState extends Equatable {
  final FormContact formContact;
  final int? id;
  final String? img;
  final bool isEdited;
  final bool isNew;

  const ContactState({
    this.formContact = const FormContact(),
    this.id,
    this.img,
    this.isEdited = false,
    this.isNew = true,
  });

  ContactState copyWith({
    FormContact? formContact,
    int? id,
    String? img,
    bool? isEdited,
    bool? isNew,
  }) {
    return ContactState(
      formContact: formContact ?? this.formContact,
      id: id ?? this.id,
      img: img ?? this.img,
      isEdited: isEdited ?? this.isEdited,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  List<Object?> get props => [formContact, img, isEdited, isNew];
}
