// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:agenda_de_contatos/data_layer/contacts_api/models/contact_model.dart';
import 'package:agenda_de_contatos/data_layer/contacts_api_sql_imp/contacts_api_sql_imp.dart';
import 'package:agenda_de_contatos/domain_layer/contacts_repository.dart';
import 'package:agenda_de_contatos/feature_layer/contactPage/contact_page_view.dart';
import 'package:agenda_de_contatos/feature_layer/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'components/contact_options_bottom_sheet.dart';
import 'components/order_options_menu_button.dart';

enum OrderOptions { orderaz, orderza }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(
          repository: ContactsRepository(contactsApi: ContactsApiSqlImp()))
        ..onDataLoaded(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos'),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: const [OrderOptionsMenuButton()],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: AddContactButton(
        onPressed: () => _showContactPage(),
      ),
      //contact list
      body: ContactList(onPressed: _showContactPage),
    );
  }

  void _showContactPage({Contact? contact}) async {
    final recContact =
        await Navigator.of(context).push(ContactPage.route(contact: contact));
    if (recContact != null) {
      if (mounted) {
        context.read<HomeCubit>().onDataLoaded();
      }
    }
  }
}

class ContactList extends StatelessWidget {
  const ContactList({
    super.key,
    required this.onPressed,
  });

  final void Function({Contact? contact}) onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, List>(
      builder: (context, state) {
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: state.length,
          itemBuilder: (context, index) {
            final Contact contact = state[index];
            String? name = contact.name;
            String? email = contact.email;
            String? phone = contact.phone;
            String? img = contact.img;

            return GestureDetector(
              //list item
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      //contact image
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: img != null
                                  ? FileImage(File(img))
                                      as ImageProvider<Object>
                                  : const AssetImage(
                                      'assets/images/person.png'),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //contact name
                            Text(
                              name,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            //contct email
                            Text(email, style: const TextStyle(fontSize: 18)),
                            //contact phone
                            Text(
                              phone,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return ContactOptionsBottomSheet(
                      onCallPressed: () => launchUrlString(phone),
                      onEditPressed: () => onPressed(contact: contact),
                      onDeletePressed: () =>
                          context.read<HomeCubit>().onDeleted(index),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class AddContactButton extends StatelessWidget {
  const AddContactButton({
    super.key,
    required this.onPressed,
  });

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.red,
      child: const Icon(Icons.add),
    );
  }
}
