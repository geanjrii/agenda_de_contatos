import 'package:agenda_de_contatos/feature_layer/contactPage/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';


class FormContact extends Equatable {
  final Name name;
  final Email email;
  final Phone phone;

  const FormContact({
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.phone = const Phone.pure(),
  });

  bool get isValid => Formz.validate([name, email, phone]);
  
  FormContact copyWith({
    Name? name,
    Email? email,
    Phone? phone,
  }) {
    return FormContact(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [name, email, phone];
}
