import 'package:agenda_de_contatos/data_layer/data_layer.dart';
import 'package:agenda_de_contatos/domain_layer/contacts_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<List<Contact>> {
  HomeCubit({required ContactsRepository repository})
      : _repository = repository,
        super([]);

  final ContactsRepository _repository;

  void onDataLoaded() async {
    List<Contact> listContact = await _repository.getAllContacts();
    emit(listContact);
  }

  Future<void> onOrderazRequested() async {
    final list = [...state];
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    emit(list);
  }

  Future<void> onOrderzaRequested() async {
    final list = [...state];
    list.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
    emit(list);
  }

  void onDeleted(int index) {
    final list = [...state];
    int id = list[index].id!;
    _repository.deleteContact(id);
    list.removeAt(index);
    emit(list);
  }
}
