// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'data_format.dart';

/// This is a private class internal to DateFormat which is used for formatting
/// particular fields in a template. e.g. if the format is hh:mm:ss then the
/// fields would be 'hh', ':', 'mm', ':', and 'ss'. Each type of field knows
/// how to format that portion of a date.
abstract class _DateFormatField {
  _DateFormatField(this.pattern, this.parent) : _trimmedPattern = pattern.trim();

  /// The DateFormat that we are part of.
  DateFormat parent;

  /// The format string that defines us, e.g. 'hh'
  final String pattern;

  /// Trimmed version of [pattern].
  final String _trimmedPattern;

  @override
  String toString() => pattern;

  /// Does this field potentially represent part of a Date, i.e. is not
  /// time-specific.
  bool get forDate => true;

  /// Return the width of [pattern]. Different widths represent different
  /// formatting options. See the comment for DateFormat for details.
  int get width => pattern.length;

  /// Format date according to our specification and return the result.
  String format(DateTime date) {
    // Default implementation in the superclass, works for both types of
    // literal patterns, and is overridden by _DateFormatPatternField.
    return pattern;
  }

  /// Format duration according to our specification and return the result.
  String formatWith(Duration duration) {
    // Default implementation in the superclass, works for both types of
    // literal patterns, and is overridden by _DateFormatPatternField.
    return pattern;
  }

  Duration resetDuration(Duration duration) {
    return duration;
  }

  String fullPattern() => pattern;

  /// Abstract method for subclasses to implementing parsing for their format.
  void parse(StringStack input, DateBuilder dateFields);

  /// Parse a literal field. We just look for the exact input.
  void parseLiteral(StringStack input) {
    var found = input.read(width);
    if (found != pattern) {
      throwFormatException(input);
    }
  }

  /// Parse a literal field. We accept either an exact match, or an arbitrary
  /// amount of whitespace.
  ///
  /// Any whitespace which occurs before or after the literal field is trimmed
  /// from the input stack. Any leading or trailing whitespace in the literal
  /// field's format specification is also trimmed before matching is
  /// attempted. Therefore, leading and trailing whitespace is optional, and
  /// arbitrary additional whitespace may be added before/after the literal.
  void parseLiteralLoose(StringStack input) {
    _trimWhitespace(input);

    var found = input.peek(_trimmedPattern.length);
    if (found == _trimmedPattern) {
      input.pop(_trimmedPattern.length);
    }

    _trimWhitespace(input);
  }

  /// Abstract method for subclasses to implementing 'loose' parsing for
  /// their format, accepting input case-insensitively, and allowing some
  /// delimiters to be skipped.
  void parseLoose(StringStack input, DateBuilder dateFields);

  /// Throw a format exception with an error message indicating the position.
  Never throwFormatException(StringStack stack) {
    throw FormatException('Trying to read $this from $stack');
  }

  void _trimWhitespace(StringStack input) {
    while (!input.atEnd && input.peek().trim().isEmpty) {
      input.pop();
    }
  }
}

/// Represents a literal field - a sequence of characters that doesn't
/// change according to the date's data. As such, the implementation
/// is extremely simple.
class _DateFormatLiteralField extends _DateFormatField {
  _DateFormatLiteralField(super.pattern, super.parent);

  @override
  void parse(StringStack input, DateBuilder dateFields) {
    parseLiteral(input);
  }

  @override
  void parseLoose(StringStack input, DateBuilder dateFields) => parseLiteralLoose(input);
}

/*
 * Represents a field in the pattern that formats some aspect of the
 * date. Consists primarily of a switch on the particular pattern characters
 * to determine what to do.
 */
class _DateFormatPatternField extends _DateFormatField {
  _DateFormatPatternField(super.pattern, super.parent);

  bool? _forDate;

  /// Is this field involved in computing the date portion, as opposed to the
  /// time.
  ///
  /// The [pattern] will contain one or more of a particular format character,
  /// e.g. 'yyyy' for a four-digit year. This hard-codes all the pattern
  /// characters that pertain to dates. The remaining characters, 'ahHkKms' are
  /// all time-related. See e.g. [formatField]
  @override
  bool get forDate => _forDate ??= 'cdDEGLMQvyZz'.contains(pattern[0]);

  /// Format date according to our specification and return the result.
  @override
  String format(DateTime date) {
    return formatField(date);
  }

  @override
  String formatWith(Duration duration) {
    return formatFieldWith(duration);
  }

  /// Parse the date according to our specification and put the result
  /// into the correct place in dateFields.
  @override
  void parse(StringStack input, DateBuilder dateFields) {
    parseField(input, dateFields);
  }

  /// Parse the date according to our specification and put the result
  /// into the correct place in dateFields. Allow looser parsing, accepting
  /// case-insensitive input and skipped delimiters.
  @override
  void parseLoose(StringStack input, DateBuilder dateFields) {
    _LoosePatternField(pattern, parent).parse(input, dateFields);
  }

  /// Return the symbols for our current locale.
  DateSymbols get symbols => parent.dateSymbols;

  String format0To11Hours(DateTime date) {
    return padTo(width, date.hour % 12);
  }

  String format0To23Hours(DateTime date) {
    return padTo(width, date.hour);
  }

  String format0To23HoursWith(Duration duration) {
    return padTo(width, duration.inHours);
  }

  String format1To12Hours(DateTime date) {
    var hours = date.hour;
    if (date.hour > 12) hours = hours - 12;
    if (hours == 0) hours = 12;
    return padTo(width, hours);
  }

  String format1To12HoursWith(Duration date) {
    var hours = date.inHours;
    if (date.inHours > 12) hours = hours - 12;
    if (hours == 0) hours = 12;
    return padTo(width, hours);
  }

  String format24Hours(DateTime date) {
    var hour = date.hour == 0 ? 24 : date.hour;
    return padTo(width, hour);
  }

  String formatAmPm(DateTime date) {
    var hours = date.hour;
    var index = (hours >= 12) && (hours < 24) ? 1 : 0;
    var ampm = symbols.AMPMS;
    return ampm[index];
  }

  String formatDayOfMonth(DateTime date) {
    return padTo(width, date.day);
  }

  String formatDayOfMonthWith(Duration duration) {
    return padTo(width, duration.inDays);
  }

  String formatDayOfWeek(DateTime date) {
    // Note that Dart's weekday returns 1 for Monday and 7 for Sunday.
    return (width >= 4 ? symbols.WEEKDAYS : symbols.SHORTWEEKDAYS)[(date.weekday) % 7];
  }

  String formatDayOfYear(DateTime date) =>
      padTo(width, date_computation.dayOfYear(date.month, date.day, date_computation.isLeapYear(date)));

  String formatEra(DateTime date) {
    var era = date.year > 0 ? 1 : 0;
    return width >= 4 ? symbols.ERANAMES[era] : symbols.ERAS[era];
  }

  /// Formatting logic if we are of type FIELD
  String formatField(DateTime date) {
    switch (pattern[0]) {
      case 'a':
        return formatAmPm(date);
      case 'c':
        return formatStandaloneDay(date);
      case 'd':
        return formatDayOfMonth(date);
      case 'D':
        return formatDayOfYear(date);
      case 'E':
        return formatDayOfWeek(date);
      case 'G':
        return formatEra(date);
      case 'h':
        return format1To12Hours(date);
      case 'H':
        return format0To23Hours(date);
      case 'K':
        return format0To11Hours(date);
      case 'k':
        return format24Hours(date);
      case 'L':
        return formatStandaloneMonth(date);
      case 'M':
        return formatMonth(date);
      case 'm':
        return formatMinutes(date);
      case 'Q':
        return formatQuarter(date);
      case 'S':
        return formatFractionalSeconds(date);
      case 's':
        return formatSeconds(date);
      case 'y':
        return formatYear(date);
      default:
        return '';
    }
  }

  String formatFieldWith(Duration duration) {
    switch (pattern[0]) {
      case 'd':
        return formatDayOfMonthWith(duration);
      case 'H':
        return format0To23HoursWith(duration);
      case 'm':
        return formatMinutesWith(duration);
      case 'S':
        return formatFractionalSecondsWith(duration);
      case 's':
        return formatSecondsWith(duration);
      case 'a':
      case 'c':
      case 'D':
      case 'E':
      case 'G':
      case 'h':
      case 'K':
      case 'k':
      case 'L':
      case 'M':
      case 'Q':
      case 'y':
        return pattern;
      default:
        return '';
    }
  }

  @override
  Duration resetDuration(Duration duration) {
    var microseconds = duration.inMicroseconds;
    switch (pattern[0]) {
      case 'd':
        return Duration(microseconds: microseconds.remainder(Duration.microsecondsPerDay));
      case 'H':
        return Duration(microseconds: microseconds.remainder(Duration.microsecondsPerHour));
      case 'm':
        return Duration(microseconds: microseconds.remainder(Duration.microsecondsPerMinute));
      case 'S':
        return Duration(microseconds: microseconds.remainder(Duration.microsecondsPerMillisecond));
      case 's':
        return Duration(microseconds: microseconds.remainder(Duration.microsecondsPerSecond));
      default:
        return duration;
    }
  }

  String formatFractionalSeconds(DateTime date) {
    // Always print at least 3 digits. If the width is greater, append 0s
    var basic = padTo(3, date.millisecond);
    if (width - 3 > 0) {
      var extra = padTo(width - 3, date.microsecond);
      return basic + extra;
    } else {
      return basic;
    }
  }

  String formatFractionalSecondsWith(Duration duration) {
    // Always print at least 3 digits. If the width is greater, append 0s
    if (width - 3 > 0) {
      return padTo(width, duration.inMicroseconds);
    } else {
      return padTo(3, duration.inMilliseconds);
    }
  }

  String formatMinutes(DateTime date) {
    return padTo(width, date.minute);
  }

  String formatMinutesWith(Duration duration) {
    return padTo(width, duration.inMinutes);
  }

  String formatMonth(DateTime date) {
    switch (width) {
      case 5:
        return symbols.NARROWMONTHS[date.month - 1];
      case 4:
        return symbols.MONTHS[date.month - 1];
      case 3:
        return symbols.SHORTMONTHS[date.month - 1];
      default:
        return padTo(width, date.month);
    }
  }

  String formatQuarter(DateTime date) {
    var quarter = ((date.month - 1) / 3).truncate();
    switch (width) {
      case 4:
        return symbols.QUARTERS[quarter];
      case 3:
        return symbols.SHORTQUARTERS[quarter];
      default:
        return padTo(width, quarter + 1);
    }
  }

  String formatSeconds(DateTime date) {
    return padTo(width, date.second);
  }

  String formatSecondsWith(Duration duration) {
    return padTo(width, duration.inSeconds);
  }

  String formatStandaloneDay(DateTime date) {
    switch (width) {
      case 5:
        return symbols.STANDALONENARROWWEEKDAYS[date.weekday % 7];
      case 4:
        return symbols.STANDALONEWEEKDAYS[date.weekday % 7];
      case 3:
        return symbols.STANDALONESHORTWEEKDAYS[date.weekday % 7];
      default:
        return padTo(1, date.day);
    }
  }

  String formatStandaloneMonth(DateTime date) {
    switch (width) {
      case 5:
        return symbols.STANDALONENARROWMONTHS[date.month - 1];
      case 4:
        return symbols.STANDALONEMONTHS[date.month - 1];
      case 3:
        return symbols.STANDALONESHORTMONTHS[date.month - 1];
      default:
        return padTo(width, date.month);
    }
  }

  String formatYear(DateTime date) {
    // TODO(alanknight): Proper handling of years <= 0
    var year = date.year;
    if (year < 0) {
      year = -year;
    }
    return width == 2 ? padTo(2, year % 100) : padTo(width, year);
  }

  /// We are given [inputStack] as an stack from which we want to read a date. We
  /// can't dynamically build up a date, so the caller has a list of the
  /// constructor arguments and a position at which to set it
  /// (year,month,day,hour,minute,second,fractionalSecond) and gives us a setter
  /// for it.
  ///
  /// Then after all parsing is done we construct a date from the
  /// arguments.
  ///
  /// This method handles reading any of the numeric fields. The [offset]
  /// argument allows us to compensate for zero-based versus one-based values.
  void handleNumericField(
    StringStack inputStack,
    void Function(int) setter, [
    int offset = 0,
  ]) {
    var result = _nextInteger(
      inputStack,
      parent.digitMatcher,
      parent.localeZeroCodeUnit,
    );
    setter(result + offset);
  }

  /// Return a string representation of the object padded to the left with
  /// zeros. Primarily useful for numbers.
  String padTo(int width, Object toBePrinted) => parent._localizeDigits('$toBePrinted'.padLeft(width, '0'));

  void parse1To12Hours(StringStack input, DateBuilder dateFields) {
    handleNumericField(input, dateFields.setHour);
    if (dateFields.hour == 12) dateFields.hour = 0;
  }

  void parseAmPm(StringStack input, DateBuilder dateFields) {
    // If we see a 'PM' note it in an extra field.
    var ampm = parseEnumeratedString(input, symbols.AMPMS);
    if (ampm == 1) dateFields.pm = true;
  }

  void parseDayOfWeek(StringStack input) {
    // This is IGNORED, but we still have to skip over it the correct amount.
    var possibilities = width >= 4 ? symbols.WEEKDAYS : symbols.SHORTWEEKDAYS;
    parseEnumeratedString(input, possibilities);
  }

  /// We are given [input] as a stack from which we want to read a date. We
  /// can't dynamically build up a date, so the caller has a list of the
  /// constructor arguments and a position at which to set it
  /// (year,month,day,hour,minute,second,fractionalSecond) and gives us a setter
  /// for it.
  ///
  /// Then after all parsing is done we construct a date from the
  /// arguments. This method handles reading any of string fields from an
  /// enumerated set.
  int parseEnumeratedString(StringStack input, List<String> possibilities) {
    var results = [
      for (var i = 0; i < possibilities.length; i++)
        if (input.peek(possibilities[i].length) == possibilities[i]) i
    ];
    if (results.isEmpty) throwFormatException(input);
    var longestResult = results.first;
    for (var result in results.skip(1)) {
      if (possibilities[result].length >= possibilities[longestResult].length) {
        longestResult = result;
      }
    }
    input.pop(possibilities[longestResult].length);
    return longestResult;
  }

  void parseEra(StringStack input) {
    var possibilities = width >= 4 ? symbols.ERANAMES : symbols.ERAS;
    parseEnumeratedString(input, possibilities);
  }

  /// Parse a field representing part of a date pattern. Note that we do not
  /// return a value, but rather build up the result in [builder].
  void parseField(StringStack input, DateBuilder builder) {
    try {
      switch (pattern[0]) {
        case 'a':
          parseAmPm(input, builder);
          break;
        case 'c':
          parseStandaloneDay(input);
          break;
        case 'd':
          handleNumericField(input, builder.setDay);
          break; // day
        // Day of year. Setting month=January with any day of the year works
        case 'D':
          handleNumericField(input, builder.setDayOfYear);
          break; // dayofyear
        case 'E':
          parseDayOfWeek(input);
          break;
        case 'G':
          parseEra(input);
          break; // era
        case 'h':
          parse1To12Hours(input, builder);
          break;
        case 'H':
          handleNumericField(input, builder.setHour);
          break; // hour 0-23
        case 'K':
          handleNumericField(input, builder.setHour);
          break; //hour 0-11
        case 'k':
          handleNumericField(input, builder.setHour, -1);
          break; //hr 1-24
        case 'L':
          parseStandaloneMonth(input, builder);
          break;
        case 'M':
          parseMonth(input, builder);
          break;
        case 'm':
          handleNumericField(input, builder.setMinute);
          break; // minutes
        case 'Q':
          break; // quarter
        case 'S':
          handleNumericField(input, builder.setFractionalSecond);
          break;
        case 's':
          handleNumericField(input, builder.setSecond);
          break;
        case 'v':
          break; // time zone id
        case 'y':
          parseYear(input, builder);
          break;
        case 'z':
          break; // time zone
        case 'Z':
          break; // time zone RFC
        default:
          return;
      }
    } catch (e) {
      throwFormatException(input);
    }
  }

  void parseMonth(StringStack input, DateBuilder dateFields) {
    List<String> possibilities;
    switch (width) {
      case 5:
        possibilities = symbols.NARROWMONTHS;
        break;
      case 4:
        possibilities = symbols.MONTHS;
        break;
      case 3:
        possibilities = symbols.SHORTMONTHS;
        break;
      default:
        return handleNumericField(input, dateFields.setMonth);
    }
    dateFields.month = parseEnumeratedString(input, possibilities) + 1;
  }

  void parseStandaloneDay(StringStack input) {
    // This is ignored, but we still have to skip over it the correct amount.
    List<String> possibilities;
    switch (width) {
      case 5:
        possibilities = symbols.STANDALONENARROWWEEKDAYS;
        break;
      case 4:
        possibilities = symbols.STANDALONEWEEKDAYS;
        break;
      case 3:
        possibilities = symbols.STANDALONESHORTWEEKDAYS;
        break;
      default:
        return handleNumericField(input, (x) => x);
    }
    parseEnumeratedString(input, possibilities);
  }

  void parseStandaloneMonth(StringStack input, DateBuilder dateFields) {
    List<String> possibilities;
    switch (width) {
      case 5:
        possibilities = symbols.STANDALONENARROWMONTHS;
        break;
      case 4:
        possibilities = symbols.STANDALONEMONTHS;
        break;
      case 3:
        possibilities = symbols.STANDALONESHORTMONTHS;
        break;
      default:
        return handleNumericField(input, dateFields.setMonth);
    }
    dateFields.month = parseEnumeratedString(input, possibilities) + 1;
  }

  void parseYear(StringStack input, DateBuilder builder) {
    handleNumericField(input, builder.setYear);
    // builder.hasAmbiguousCentury = width == 2;
    builder.setHasAmbiguousCentury(width == 2);
  }

  /// Read as much content as [digitMatcher] matches from the current position,
  /// and parse the result as an integer, advancing the index.
  ///
  /// The regular expression [digitMatcher] is used to find the substring which
  /// matches an integer.
  /// The codeUnit of the local zero [zeroDigit] is used to anchor the parsing
  /// into digits.
  int _nextInteger(StringStack inputStack, RegExp digitMatcher, int zeroDigit) {
    var string = digitMatcher.stringMatch(inputStack.peekAll());
    if (string == null || string.isEmpty) {
      return throwFormatException(inputStack);
    }
    inputStack.pop(string.length);
    if (zeroDigit != constants.asciiZeroCodeUnit) {
      // Trying to optimize this, as it might get called a lot. See the
      // benchmark at benchmark/intl_stream_benchmark.dart
      var codeUnits = string.codeUnits;
      string = String.fromCharCodes(List.generate(
        codeUnits.length,
        (index) => codeUnits[index] - zeroDigit + constants.asciiZeroCodeUnit,
        growable: false,
      ));
    }
    return int.parse(string);
  }
}

/// Represents a literal field with quoted characters in it. This is
/// only slightly more complex than a _DateFormatLiteralField.
class _DateFormatQuotedField extends _DateFormatField {
  _DateFormatQuotedField(String pattern, DateFormat parent)
      : _fullPattern = pattern,
        super(_patchQuotes(pattern), parent);

  static final _twoEscapedQuotes = RegExp(r"''");

  final String _fullPattern;

  @override
  String fullPattern() => _fullPattern;

  @override
  void parse(StringStack input, DateBuilder dateFields) {
    parseLiteral(input);
  }

  @override
  void parseLoose(StringStack input, DateBuilder dateFields) => parseLiteralLoose(input);

  static String _patchQuotes(String pattern) {
    if (pattern == "''") {
      return "'";
    } else {
      return pattern.substring(1, pattern.length - 1).replaceAll(_twoEscapedQuotes, "'");
    }
  }
}

/// A field that parses 'loosely', meaning that we'll accept input that is
/// missing delimiters, has upper/lower case mixed up, and might not strictly
/// conform to the pattern, e.g. the pattern calls for Sep we might accept
/// sep, september, sEPTember. Doesn't affect numeric fields.
class _LoosePatternField extends _DateFormatPatternField {
  _LoosePatternField(super.pattern, super.parent);

  /// Parse a day of the week name, case-insensitively.
  /// Assumes that input is lower case. Doesn't do anything
  @override
  void parseDayOfWeek(StringStack input) {
    // This is IGNORED, but we still have to skip over it the correct amount.
    if (width <= 2) {
      handleNumericField(input, (x) => x);
      return;
    }
    var possibilities = [symbols.WEEKDAYS, symbols.SHORTWEEKDAYS];
    for (var dayNames in possibilities) {
      var day = parseEnumeratedString(input, dayNames);
      if (day != -1) {
        return;
      }
    }
  }

  /// Parse from a list of possibilities, but case-insensitively.
  /// Assumes that input is lower case.
  @override
  int parseEnumeratedString(StringStack input, List<String> possibilities) {
    var lowercasePossibilities = possibilities.map((x) => x.toLowerCase()).toList();
    try {
      return super.parseEnumeratedString(input, lowercasePossibilities);
    } on FormatException {
      return -1;
    }
  }

  /// Parse a month name, case-insensitively, and set it in [dateFields].
  /// Assumes that [input] is lower case.
  @override
  void parseMonth(StringStack input, DateBuilder dateFields) {
    if (width <= 2) {
      handleNumericField(input, dateFields.setMonth);
      return;
    }
    var possibilities = [symbols.MONTHS, symbols.SHORTMONTHS];
    for (var monthNames in possibilities) {
      var month = parseEnumeratedString(input, monthNames);
      if (month != -1) {
        dateFields.month = month + 1;
        return;
      }
    }
    throwFormatException(input);
  }

  /// Parse a standalone day name, case-insensitively.
  /// Assumes that input is lower case. Doesn't do anything
  @override
  void parseStandaloneDay(StringStack input) {
    // This is ignored, but we still have to skip over it the correct amount.
    if (width <= 2) {
      handleNumericField(input, (x) => x);
      return;
    }
    var possibilities = [symbols.STANDALONEWEEKDAYS, symbols.STANDALONESHORTWEEKDAYS];
    for (var dayNames in possibilities) {
      var day = parseEnumeratedString(input, dayNames);
      if (day != -1) {
        return;
      }
    }
  }

  /// Parse a standalone month name, case-insensitively, and set it in
  /// [dateFields]. Assumes that input is lower case.
  @override
  void parseStandaloneMonth(StringStack input, DateBuilder dateFields) {
    if (width <= 2) {
      handleNumericField(input, dateFields.setMonth);
      return;
    }
    var possibilities = [symbols.STANDALONEMONTHS, symbols.STANDALONESHORTMONTHS];
    for (var monthNames in possibilities) {
      var month = parseEnumeratedString(input, monthNames);
      if (month != -1) {
        dateFields.month = month + 1;
        return;
      }
    }
    throwFormatException(input);
  }
}

extension DateFormatExt on DateFormat {
  /// Given a numeric string in ASCII digits, return a copy updated for our
  /// locale digits.
  String _localizeDigits(String numberString) {
    if (usesAsciiDigits) return numberString;
    var newDigits = List<int>.filled(numberString.length, 0);
    var oldDigits = numberString.codeUnits;
    for (var i = 0; i < numberString.length; i++) {
      newDigits[i] = oldDigits[i] + localeZeroCodeUnit - constants.asciiZeroCodeUnit;
    }
    return String.fromCharCodes(newDigits);
  }
}
