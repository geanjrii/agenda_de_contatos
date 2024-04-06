// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:agenda_de_contatos/data_layer/data_layer.dart';
import 'package:agenda_de_contatos/domain_layer/contacts_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'components/discard_changes_dialog.dart';
import 'cubit/contact_cubit.dart';

class ContactPage extends StatelessWidget {
  const ContactPage._({this.contact});

  final Contact? contact;

  static MaterialPageRoute route({required Contact? contact}) {
    return MaterialPageRoute(
        builder: (context) => ContactPage._(contact: contact));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContactCubit(
          repository: ContactsRepository(contactsApi: ContactsApiSqlImp()))
        ..init(contact),
      child: const ContactView(),
    );
  }
}

class ContactView extends StatefulWidget {
  const ContactView({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api  
  _ContactViewState createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  @override
  Widget build(BuildContext context) {
    final isEdited =
        context.select((ContactCubit cubit) => cubit.state.isEdited);
    final isNotEdited = !isEdited;
    final isNew = context.select((ContactCubit cubit) => cubit.state.isNew);
    final value =
        context.select((ContactCubit cubit) => cubit.state.formContact.name.value);
    return Form(
      canPop: isNotEdited || isNew,
      onPopInvoked: (didPop) {
        if (!didPop) {
          DiscardChangesDialog.showDiscardChangesDialog(context, isEdited);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(value.isNotEmpty ? value : 'Novo Contato'),
          centerTitle: true,
        ),
        //save button
        floatingActionButton: const SaveButton(),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Form(
            child: Column(
              children: [
                ContactImage(),
                NameTextField(),
                EmailTextField(),
                PhoneTextField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isValid = context.watch<ContactCubit>().state.formContact.isValid;
    return FloatingActionButton(
      onPressed: isValid
          ? () {
              context.read<ContactCubit>().onSubmitted();
              Navigator.pop(context, true);
            }
          : null,
      backgroundColor: Colors.red,
      child: const Icon(Icons.save),
    );
  }
}

class ContactImage extends StatelessWidget {
  const ContactImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final img = context.watch<ContactCubit>().state.img;
    return GestureDetector(
      onTap: () {
        ImagePicker().pickImage(source: ImageSource.camera).then((pickedFile) {
          if (pickedFile != null) {
            context.read<ContactCubit>().onImageChanged(pickedFile.path);
          }
        });
      },
      //contact icon image
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: img != null
                ? FileImage(File(img))
                : const AssetImage('assets/images/person.png')
                    as ImageProvider<Object>,
          ),
        ),
      ),
    );
  }
}

class NameTextField extends StatefulWidget {
  const NameTextField({
    super.key,
  });

  @override
  State<NameTextField> createState() => _NameTextFieldState();
}

class _NameTextFieldState extends State<NameTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = context.watch<ContactCubit>().state.formContact.name.value;
    final erro = context.read<ContactCubit>().state.formContact.name.displayError;
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Nome',
        errorText: erro != null ? 'Invalid name' : null,
      ),
      onChanged: (name) => context.read<ContactCubit>().onNameChanged(name),
    );
  }
}

class EmailTextField extends StatefulWidget {
  const EmailTextField({
    super.key,
  });

  @override
  State<EmailTextField> createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<EmailTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = context.watch<ContactCubit>().state.formContact.email.value;
    final erro = context.read<ContactCubit>().state.formContact.email.displayError;

    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: erro != null ? 'Invalid email' : null,
      ),
      onChanged: (email) => context.read<ContactCubit>().onEmailChanged(email),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class PhoneTextField extends StatefulWidget {
  const PhoneTextField({
    super.key,
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = context.watch<ContactCubit>().state.formContact.phone.value;
    final erro = context.read<ContactCubit>().state.formContact.phone.displayError;

    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Phone',
        errorText: erro != null ? 'Invalid phone' : null,
      ),
      onChanged: (phone) => context.read<ContactCubit>().onPhoneChanged(phone),
      keyboardType: TextInputType.phone,
    );
  }
}
