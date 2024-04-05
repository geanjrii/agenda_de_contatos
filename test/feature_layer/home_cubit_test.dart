import 'package:agenda_de_contatos/data_layer/data_layer.dart';
import 'package:agenda_de_contatos/domain_layer/contacts_repository.dart';
import 'package:agenda_de_contatos/feature_layer/home/cubit/home_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
  final mockContacts = [
    const Contact(id: 1, name: 'John Doe', email: '', phone: ''),
    const Contact(id: 2, name: 'Jane Smith', email: '', phone: ''),
  ];

  group('HomeCubit', () {
    late HomeCubit homeCubit;
    late ContactsRepository mockRepository;

    setUp(() {
      mockRepository = MockContactsRepository();
      homeCubit = HomeCubit(repository: mockRepository);
    });

    tearDown(() {
      homeCubit.close();
    });

    test('initial state is empty', () {
      expect(homeCubit.state, isEmpty);
    });

    blocTest<HomeCubit, List<Contact>>(
      'emits contacts when onDataLoaded is called',
      setUp: () {
        when(() => mockRepository.getAllContacts())
            .thenAnswer((_) async => mockContacts);
      },
      build: () => homeCubit,
      act: (cubit) => cubit.onDataLoaded(),
      expect: () => [mockContacts],
      verify: (_) {
        verify(() => mockRepository.getAllContacts()).called(1);
      },
    );

    blocTest<HomeCubit, List<Contact>>(
      'emits sorted contacts when onOrderazRequested is called',
      seed: () => mockContacts,
      build: () => homeCubit,
      act: (cubit) => cubit.onOrderazRequested(),
      expect: () => [
        mockContacts
          ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()))
      ],
    );

    blocTest<HomeCubit, List<Contact>>(
      'emits sorted contacts when onOrderzaRequested is called',
      seed: () => mockContacts,
      build: () => homeCubit,
      act: (cubit) => cubit.onOrderzaRequested(),
      expect: () => [
        mockContacts
          ..sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()))
      ],
    );

    blocTest<HomeCubit, List<Contact>>(
      'emits updated contacts when onDeleted is called',
      setUp: () {
        when(() => mockRepository.deleteContact(any())).thenAnswer((_) async {
          return null;
        });
      },
      seed: () => mockContacts,
      build: () => homeCubit,
      act: (cubit) => cubit.onDeleted(0),
      expect: () => [mockContacts..removeAt(0)],
      verify: (_) {
        verify(() => mockRepository.deleteContact(any())).called(1);
      },
    );
  });
}
