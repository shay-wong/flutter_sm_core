import 'package:flutter_test/flutter_test.dart';
import 'package:sm_core/sm_core.dart';

void main() {
  test('date format', () {
    MDateFormat smDateFormat = MDateFormat("yyyy-MM-dd HH:mm:ss");
    final date = DateTime.parse('2022-01-01 22:56:00Z');
    expect(smDateFormat.format(date), "2022-01-01 22:56:00");

    final seconds = 1.days + 1.hours + 1.minutes + 1.seconds;

    expect(smDateFormat.formatWith(seconds), '--01 01:01:01');
  });
}
