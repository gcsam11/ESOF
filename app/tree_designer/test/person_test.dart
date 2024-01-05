import 'package:flutter_test/flutter_test.dart';
import 'package:tree_designer/data_classes/person.dart';

void main() {
  group('Person', () {
    test('default values', () {
      final person = Person(treeId: '0000');
      expect(person.treeId, '0000');
      expect(person.name, 'undefined');
      expect(person.age, 0);
      expect(person.sex, 'undefined');
      expect(person.birthPlace, 'undefined');
      expect(person.nationality, 'undefined');
    });

    test('given values', () {
      final person = Person(treeId: '1234', personId: '4321', imageUrl: 'https://res.cloudinary.com/teepublic/image/private/s--bsV1IX9---/t_Resized%20Artwork/c_fit,g_north_west,h_954,w_954/co_0195c3,e_outline:48/co_0195c3,e_outline:inner_fill:48/co_ffffff,e_outline:48/co_ffffff,e_outline:inner_fill:48/co_bbbbbb,e_outline:3:1000/c_mpad,g_center,h_1260,w_1260/b_rgb:eeeeee/c_limit,f_auto,h_630,q_90,w_630/v1664730129/production/designs/35364891_0.jpg', name: 'Joe', age: 34, sex: 'male', birthDate: DateTime(2003,7,18), birthPlace: 'London',deathDate: DateTime(2021,8,19), nationality: 'English', parent1Id: '1111', parent2Id: '2222');
      expect(person.treeId, '1234');
      expect(person.personId, '4321');
      expect(person.name, 'Joe');
      expect(person.age, 34);
      expect(person.sex, 'male');
      expect(person.birthDate, DateTime(2003, 7, 18));
      expect(person.birthPlace, 'London');
      expect(person.deathDate, DateTime(2021,8,19));
      expect(person.nationality, 'English');
      expect(person.parent1Id, '1111');
      expect(person.parent2Id, '2222');
    });

    test('update values', () {
      final person = Person(treeId: '0000');
      person.updateName('John Doe');
      person.updateAge(30);
      person.updateSex('male');
      person.updateBirthDate(DateTime(1990, 1, 1));
      person.updateBirthPlace('New York');
      person.updateDeathDate(DateTime(2020, 1, 1));
      person.updateNationality('American');

      expect(person.name, 'John Doe');
      expect(person.age, 30);
      expect(person.sex, 'male');
      expect(person.birthDate, DateTime(1990, 1, 1));
      expect(person.birthPlace, 'New York');
      expect(person.deathDate, DateTime(2020, 1, 1));
      expect(person.nationality, 'American');
    });

    test('invalid age value', () {
      final person = Person(treeId: '0000');
      expect(() => person.updateAge(-1), throwsException);
      expect(() => person.updateAge(321), throwsException);
    });
  });
}
