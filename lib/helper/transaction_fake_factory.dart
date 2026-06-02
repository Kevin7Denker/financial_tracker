import 'package:faker_dart/faker_dart.dart';
import '../domain/entity/transaction_entity.dart';

abstract class TransactionFakeFactory {
  static TransactionEntity factory() {
    final faker = Faker.instance;
    faker.setLocale(FakerLocaleType.pt_PT);
    final now = DateTime.now();
    final bucket = faker.datatype.number(min: 0, max: 4);
    final date = switch (bucket) {
      0 => _randomDateWithin(now, const Duration(days: 1)),
      1 => _randomDateWithin(now, const Duration(days: 7)),
      2 => _randomDateWithin(now, const Duration(days: 30)),
      3 => _randomDateWithin(now, const Duration(days: 90)),
      _ => _randomDateWithin(now, const Duration(days: 365)),
    };

    var instance = TransactionEntity(
      title: faker.commerce.productName(),
      type:
          (faker.datatype.boolean())
              ? TransactionType.income
              : TransactionType.expense,
      date: date,
      amount: faker.datatype.float(min: 100.0, max: 2000.0, precision: 2),
    );
    return instance;
  }

  static DateTime _randomDateWithin(DateTime now, Duration span) {
    final rangeInMinutes = span.inMinutes;
    final offsetInMinutes = fakerNumberInRange(0, rangeInMinutes);

    return now.subtract(Duration(minutes: offsetInMinutes));
  }

  static int fakerNumberInRange(int min, int max) {
    final faker = Faker.instance;
    return faker.datatype.number(min: min, max: max);
  }
}
