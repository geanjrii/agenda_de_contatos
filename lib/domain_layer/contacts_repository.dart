import 'package:agenda_de_contatos/data_layer/data_layer.dart';

class ContactsRepository {
  final ContactsApi _contactsApi;

  ContactsRepository({required ContactsApi contactsApi})
      : _contactsApi = contactsApi;

  Future<Contact> saveContact(Contact contact) {
    return _contactsApi.saveContact(contact);
  }

  Future<Contact?> getContact(int id) {
    return _contactsApi.getContact(id);
  }

  Future<int?> deleteContact(int id) {
    return _contactsApi.deleteContact(id);
  }

  Future<int> updateContact(Contact contact) {
    return _contactsApi.updateContact(contact);
  }

  Future<List<Contact>> getAllContacts() {
    return _contactsApi.getAllContacts();
  }

  Future<int?> getNumber() {
    return _contactsApi.getNumber();
  }

  Future<void> close() {
    return _contactsApi.close();
  }
}
