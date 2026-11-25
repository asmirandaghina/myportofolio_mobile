import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/lakon.dart';

void main() {
  group('Lakon', () {
    test('fromJson membaca field snake_case dari Django', () {
      final lakon = Lakon.fromJson(const {
        'id': 'abc-123',
        'title': 'Kalimba',
        'category': 'musik',
        'category_display': 'Musik',
        'photo': 'img/lakoni/kalimba.jpg',
        'star_count': 3,
        'is_starred': true,
        'starred_by_names': 'ghina',
      });

      expect(lakon.id, 'abc-123');
      expect(lakon.categoryDisplay, 'Musik');
      expect(lakon.starCount, 3);
      expect(lakon.isStarred, isTrue);
    });

    test('photo yang null menjadi string kosong', () {
      final lakon = Lakon.fromJson(const {
        'id': '1',
        'title': 'Tanpa foto',
        'category': 'seni',
        'photo': null,
      });

      expect(lakon.photo, '');
    });

    test('toJson hanya mengirim title, category, dan photo', () {
      const lakon = Lakon(
        id: 'abc-123',
        title: 'Kalimba',
        category: 'musik',
        starCount: 5,
      );

      expect(lakon.toJson(), {
        'title': 'Kalimba',
        'category': 'musik',
        'photo': '',
      });
    });
  });
}
