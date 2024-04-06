import 'package:agenda_de_contatos/data_layer/contacts_api/models/contact_model.dart';
import 'package:agenda_de_contatos/domain_layer/contacts_repository.dart';
import 'package:agenda_de_contatos/feature_layer/contactPage/cubit/contact_cubit.dart';
import 'package:agenda_de_contatos/feature_layer/contactPage/models/models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
  const mockFormContact = FormContact(
    name: Name.dirty('John Doe'),
    email: Email.dirty('john@example.com'),
    phone: Phone.dirty('(83) 98888-8888'),
  );

  const mockContact = Contact(
    name: 'John Doe',
    email: 'john@example.com',
    phone: '(83) 98888-8888',
    img: '',
    id: 1,
  );

  const mockNewContact = Contact(
    name: 'John Doe',
    email: 'john@example.com',
    phone: '(83) 98888-8888',
    img: '',
  );
  group('ContactCubit', () {
    late ContactCubit contactCubit;
    late ContactsRepository mockRepository;

    setUp(() {
      mockRepository = MockContactsRepository();
      contactCubit = ContactCubit(repository: mockRepository);
    });

    tearDown(() {
      contactCubit.close();
    });

    test('initial state is correct', () {
      expect(contactCubit.state, const ContactState());
    });

    blocTest<ContactCubit, ContactState>(
      'emits correct state when init is called with a contact',
      build: () => contactCubit,
      act: (cubit) => cubit.init(mockContact),
      expect: () => [
        const ContactState(
          formContact: mockFormContact,
          img: '',
          id: 1,
          isEdited: false,
          isNew: false,
        ),
      ],
    );

    blocTest<ContactCubit, ContactState>(
      'emits correct state when onNameChanged is called',
      seed: () => const ContactState(formContact: mockFormContact),
      build: () => contactCubit,
      act: (cubit) => cubit.onNameChanged('John Doe'),
      expect: () => [
        const ContactState(
          formContact: mockFormContact,
          isEdited: true,
        ),
      ],
    );

    blocTest<ContactCubit, ContactState>(
      'emits correct state when onEmailChanged is called',
      seed: () => const ContactState(formContact: mockFormContact),
      build: () => contactCubit,
      act: (cubit) => cubit.onEmailChanged('john@example.com'),
      expect: () => [
        const ContactState(
          formContact: mockFormContact,
          isEdited: true,
        ),
      ],
    );

    blocTest<ContactCubit, ContactState>(
      'emits correct state when onPhoneChanged is called',
      seed: () => const ContactState(formContact: mockFormContact),
      build: () => contactCubit,
      act: (cubit) => cubit.onPhoneChanged('(83) 98888-8888'),
      expect: () => [
        const ContactState(
          formContact: mockFormContact,
          isEdited: true,
        ),
      ],
    );

    blocTest<ContactCubit, ContactState>(
      'emits correct state when onImageChanged is called',
      seed: () => const ContactState(formContact: mockFormContact),

      build: () => contactCubit,
      act: (cubit) => cubit.onImageChanged('image.jpg'),
      expect: () => [
        const ContactState(
          formContact: mockFormContact,
          img: 'image.jpg',
          isEdited: true,
        ),
      ],
    );

    blocTest<ContactCubit, ContactState>(
      'does not save or update contact when onSubmitted is called with invalid state',
      build: () => contactCubit,
      act: (cubit) => cubit.onSubmitted(),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockRepository.saveContact(mockContact));
        verifyNever(() => mockRepository.updateContact(mockContact));
      },
    );

    blocTest<ContactCubit, ContactState>(
      'saves new contact when onSubmitted is called with valid state and isNew is true',
      setUp: () {
        when(() => mockRepository.saveContact(mockNewContact))
            .thenAnswer((_) async {
          return mockNewContact;
        });
      },
      build: () => contactCubit,
      seed: () => const ContactState(
        formContact: mockFormContact,
        img: '',
        isEdited: true,
        isNew: true,
      ),
      act: (cubit) => cubit.onSubmitted(),
      verify: (_) {
        verify(() => mockRepository.saveContact(mockNewContact)).called(1);
        verifyNever(() => mockRepository.updateContact(mockNewContact));
      },
    );

    blocTest<ContactCubit, ContactState>(
      'updates existing contact when onSubmitted is called with valid state and isNew is false',
      setUp: () {
        when(() => mockRepository.updateContact(mockContact))
            .thenAnswer((_) async {
          return 1;
        });
      },
      build: () => contactCubit,
      seed: () => const ContactState(
        formContact: mockFormContact,
        img: '',
        isEdited: true,
        isNew: false,
        id: 1,
      ),
      act: (cubit) => cubit.onSubmitted(),
      verify: (_) {
        verifyNever(() => mockRepository.saveContact(mockContact));
        verify(() => mockRepository.updateContact(mockContact)).called(1);
      },
    );
  });
}
