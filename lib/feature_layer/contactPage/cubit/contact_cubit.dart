import 'package:agenda_de_contatos/data_layer/contacts_api/models/contact_model.dart';
import 'package:agenda_de_contatos/domain_layer/contacts_repository.dart';
import 'package:agenda_de_contatos/feature_layer/contactPage/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit({required ContactsRepository repository})
      : _repository = repository,
        super(const ContactState());

  final ContactsRepository _repository;

  void init(Contact? contact) {
    if (contact != null) {
      emit(state.copyWith(
        formContact: FormContact(
          name: Name.dirty(contact.name),
          email: Email.dirty(contact.email),
          phone: Phone.dirty(contact.phone),
        ),
        img: contact.img,
        id: contact.id,
        isNew: false,
      ));
    }
  }

  void onNameChanged(String name) {
    emit(state.copyWith(
      formContact: state.formContact.copyWith(name: Name.dirty(name)),
      isEdited: true,
    ));
  }

  void onEmailChanged(String email) {
    emit(state.copyWith(
      formContact: state.formContact.copyWith(email: Email.dirty(email)),
      isEdited: true,
    ));
  }

  void onPhoneChanged(String phone) {
    emit(state.copyWith(
      formContact: state.formContact.copyWith(phone: Phone.dirty(phone)),
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
    if (!state.formContact.isValid) return;
    final contact = Contact(
      name: state.formContact.name.value,
      email: state.formContact.email.value,
      phone: state.formContact.phone.value,
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
