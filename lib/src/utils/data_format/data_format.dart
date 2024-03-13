// ignore_for_file: implementation_imports

import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import "package:intl/src/intl/constants.dart" as constants;
import 'package:intl/src/intl/date_builder.dart';
import 'package:intl/src/intl/date_computation.dart' as date_computation;
import 'package:intl/src/intl/string_stack.dart';

part '_date_format_field.dart';

// TODO: 对 intl 解耦
class MDateFormat extends DateFormat {
  MDateFormat([super.newPattern, super.locale]);

  /// A series of regular expressions used to parse a format string into its
  /// component fields.
  static final List<RegExp> _matchers = [
    // Quoted String - anything between single quotes, with escaping
    //   of single quotes by doubling them.
    // e.g. in the pattern 'hh 'o''clock'' will match 'o''clock'
    RegExp('^\'(?:[^\']|\'\')*\''),
    // Fields - any sequence of 1 or more of the same field characters.
    // e.g. in 'hh:mm:ss' will match hh, mm, and ss. But in 'hms' would
    // match each letter individually.
    RegExp('^(?:G+|y+|M+|k+|S+|E+|a+|h+|K+|H+|c+|L+|Q+|d+|D+|m+|s+|v+|z+|Z+)'),
    // Everything else - A sequence that is not quotes or field characters.
    // e.g. in 'hh:mm:ss' will match the colons.
    RegExp('^[^\'GyMkSEahKHcLQdDmsvzZ]+')
  ];

  /// We parse the format string into individual [_DateFormatField] objects
  /// that are used to do the actual formatting and parsing. Do not use
  /// this variable directly, use the getter [_formatFields].
  List<_DateFormatField>? _formatFieldsPrivate;

  /// Add [inputPattern] to this instance as a pattern.
  ///
  /// If there was a previous pattern, then this appends to it, separating the
  /// two by [separator].  [inputPattern] is first looked up in our list of
  /// known skeletons.  If it's found there, then use the corresponding pattern
  /// for this locale.  If it's not, then treat [inputPattern] as an explicit
  /// pattern.
  @override
  DateFormat addPattern(String? inputPattern, [String separator = ' ']) {
    // TODO(alanknight): This is an expensive operation. Caching recently used
    // formats, or possibly introducing an entire 'locale' object that would
    // cache patterns for that locale could be a good optimization.
    // If we have already parsed the format fields, reset them.
    _formatFieldsPrivate = null;
    return super.addPattern(inputPattern, separator);
  }

  static List<_DateFormatField Function(String, DateFormat)> get _fieldConstructors => [
        (pattern, parent) => _DateFormatQuotedField(pattern, parent),
        (pattern, parent) => _DateFormatPatternField(pattern, parent),
        (pattern, parent) => _DateFormatLiteralField(pattern, parent)
      ];

  /// Getter for [_formatFieldsPrivate] that lazily initializes it.
  List<_DateFormatField> get _formatFields {
    if (_formatFieldsPrivate == null) {
      if (pattern == null) _useDefaultPattern();
      _formatFieldsPrivate = _parsePattern(pattern!);
    }
    return _formatFieldsPrivate!;
  }

  /// Return a string representing [date] formatted according to our locale
  /// and internal format.
  String formatWith(Duration duration) {
    var result = StringBuffer();
    for (var field in _formatFields) {
      result.write(field.formatWith(duration));
      duration = field.resetDuration(duration);
    }
    return result.toString();
  }

  /// Find elements in a string that are patterns for specific fields.
  _DateFormatField? _match(String pattern) {
    for (var i = 0; i < _matchers.length; i++) {
      var regex = _matchers[i];
      var match = regex.firstMatch(pattern);
      if (match != null) {
        return _fieldConstructors[i](match.group(0)!, this);
      }
    }
    return null;
  }

  List<_DateFormatField> _parsePattern(String pattern) {
    return _parsePatternHelper(pattern).reversed.toList();
  }

  /// Recursive helper for parsing the template pattern.
  List<_DateFormatField> _parsePatternHelper(String pattern) {
    if (pattern.isEmpty) return [];

    var matched = _match(pattern);
    if (matched == null) return [];

    var parsed = _parsePatternHelper(pattern.substring(matched.fullPattern().length));
    parsed.add(matched);
    return parsed;
  }

  /// We are being asked to do formatting without having set any pattern.
  /// Use a default.
  void _useDefaultPattern() {
    add_yMMMMd();
    add_jms();
  }
}
