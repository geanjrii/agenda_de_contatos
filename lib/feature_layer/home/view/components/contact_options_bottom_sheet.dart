// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ContactOptionsBottomSheet extends StatelessWidget {
  final void Function() onCallPressed;
  final void Function() onEditPressed;
  final void Function() onDeletePressed;
  const ContactOptionsBottomSheet({
    super.key,
    required this.onCallPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CallButton(onPressed: onCallPressed),
              EditButton(onPressed: onEditPressed),
              DeleteButton(onPressed: onDeletePressed),
            ],
          ),
        );
      },
    );
  }
}

class CallButton extends StatelessWidget {
  const CallButton({
    super.key,
    required this.onPressed,
  });

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
          onPressed();
        },
        child: const Text(
          'Ligar',
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  const EditButton({
    super.key,
    required this.onPressed,
  });

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
          onPressed();
        },
        child: const Text(
          'Editar',
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
    required this.onPressed,
  });

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
          onPressed();
        },
        child: const Text(
          'Excluir',
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
