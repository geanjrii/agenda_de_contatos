import 'package:agenda_de_contatos/data_layer/contacts_api/models/contact_model.dart';
import 'package:agenda_de_contatos/domain_layer/contacts_repository.dart';
import 'package:agenda_de_contatos/feature_layer/contactPage/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit({required ContactsRepository repository})
      : _repository = repository,
        super(const ContactState());

  final ContactsRepository _repository;

  void init(Contact? contact) {
    if (contact != null) {
      emit(state.copyWith(
        name: Name.dirty(contact.name),
        email: Email.dirty(contact.email),
        phone: Phone.dirty(contact.phone),
        img: contact.img,
        id: contact.id,
        isNew: false,
        isValid: Formz.validate([
          Name.dirty(contact.name),
          Email.dirty(contact.email),
          Phone.dirty(contact.phone),
        ]),
      ));
    }
  }

  void onNameChanged(String name) {
    emit(state.copyWith(
      name: Name.dirty(name),
      isValid: Formz.validate([Name.dirty(name), state.email, state.phone]),
      isEdited: true,
    ));
  }

  void onEmailChanged(String email) {
    emit(state.copyWith(
      email: Email.dirty(email),
      isValid: Formz.validate([state.name, Email.dirty(email), state.phone]),
      isEdited: true,
    ));
  }

  void onPhoneChanged(String phone) {
    emit(state.copyWith(
      phone: Phone.dirty(phone),
      isValid: Formz.validate([state.name, state.email, Phone.dirty(phone)]),
      isEdited: true,
    ));
  }

  void onImageChanged(String img) {
    emit(state.copyWith(
      img: img,
      isEdited: true,
    ));
  }

  void onSubmitted() {
    if (!state.isValid) return;
    final contact = Contact(
      name: state.name.value,
      email: state.email.value,
      phone: state.phone.value,
      img: state.img,
      id: state.id,
    );
    if (state.isNew) {
      _repository.saveContact(contact);
    } else {
      _repository.updateContact(contact);
    }
  }
}
