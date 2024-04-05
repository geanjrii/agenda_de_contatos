import 'models/contact_model.dart';

abstract interface class ContactsApi {
  Future<Contact> saveContact(Contact contact);

  Future<Contact?> getContact(int id);

  Future<int?> deleteContact(int id);

  Future<int> updateContact(Contact contact);

  Future<List<Contact>> getAllContacts();

  Future<int?> getNumber();

  Future<void> close();
}
