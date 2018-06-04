// https://github.com/nodatime/nodatime/blob/master/src/NodaTime.Test/Text/PeriodPatternTest.Roundtrip.cs
// 69dedbc  on Apr 23

import 'dart:async';
import 'dart:math' as math;
import 'dart:mirrors';

import 'package:time_machine/time_machine.dart';
import 'package:time_machine/time_machine_calendars.dart';
import 'package:time_machine/time_machine_globalization.dart';
import 'package:time_machine/time_machine_patterns.dart';
import 'package:time_machine/time_machine_text.dart';
import 'package:time_machine/time_machine_utilities.dart';

import 'package:test/test.dart';
import 'package:matcher/matcher.dart';
import 'package:time_machine/time_machine_timezones.dart';

import '../time_machine_testing.dart';
import 'pattern_test_base.dart';
import 'pattern_test_data.dart';
import 'test_cultures.dart';
import 'text_cursor_test_base_tests.dart';

import 'period_pattern_test.dart';

Future main() async {
  await runTests();
}

@Test()
class PeriodPatternRoundtripTest extends PatternTestBase<Period> {
  @internal final List<Data> InvalidPatternData = [ null];

  @internal List<Data> ParseFailureData = [
    new Data()
      ..Text = "X5H"
      ..Message = TextErrorMessages.MismatchedCharacter
      ..Parameters.addAll(['P']),
    new Data()
      ..Text = ""
      ..Message = TextErrorMessages.ValueStringEmpty,
    new Data()
      ..Text = "PJ"
      ..Message = TextErrorMessages.MissingNumber,
    new Data()
      ..Text = "P5J"
      ..Message = TextErrorMessages.InvalidUnitSpecifier
      ..Parameters.addAll(['J']),
    new Data()
      ..Text = "P5D10M"
      ..Message = TextErrorMessages.MisplacedUnitSpecifier
      ..Parameters.addAll(['M']),
    new Data()
      ..Text = "P6M5D6D"
      ..Message = TextErrorMessages.RepeatedUnitSpecifier
      ..Parameters.addAll(['D']),
    new Data()
      ..Text = "PT5M10H"
      ..Message = TextErrorMessages.MisplacedUnitSpecifier
      ..Parameters.addAll(['H']),
    new Data()
      ..Text = "P5H"
      ..Message = TextErrorMessages.MisplacedUnitSpecifier
      ..Parameters.addAll(['H']),
    new Data()
      ..Text = "PT5Y"
      ..Message = TextErrorMessages.MisplacedUnitSpecifier
      ..Parameters.addAll(['Y']),
    new Data()
      ..Text = "PX"
      ..Message = TextErrorMessages.MissingNumber,
    new Data()
      ..Text = "P10M-"
      ..Message = TextErrorMessages.EndOfString,
    new Data()
      ..Text = "P5"
      ..Message = TextErrorMessages.EndOfString,
    new Data()
      ..Text = "P9223372036854775808H"
      ..Message = TextErrorMessages.ValueOutOfRange
      ..Parameters.addAll(["9223372036854775808", 'Period']),
    new Data()
      ..Text = "P-9223372036854775809H"
      ..Message = TextErrorMessages.ValueOutOfRange
      ..Parameters.addAll(["-9223372036854775809", 'Period']),
    new Data()
      ..Text = "P10000000000000000000H"
      ..Message = TextErrorMessages.ValueOutOfRange
      ..Parameters.addAll(["10000000000000000000", 'Period']),
    new Data()
      ..Text = "P-10000000000000000000H"
      ..Message = TextErrorMessages.ValueOutOfRange
      ..Parameters.addAll(["-10000000000000000000", 'Period']),
  ];

  @internal List<Data> ParseOnlyData = [
    new Data.builder(new PeriodBuilder()..Hours = 5)
      ..Text = "PT005H",
    new Data.builder(new PeriodBuilder()..Hours = 5)
      ..Text = "PT00000000000000000000005H",
  ];

// This pattern round-trips, so we can always parse what we format.
  @internal List<Data> FormatOnlyData = [];

  @internal static final List<Data> FormatAndParseData = [
    new Data(Period.Zero)
      ..Text = "P",

// All single values                                                                
    new Data.builder(new PeriodBuilder()..Years = 5)
      ..Text = "P5Y",
    new Data.builder(new PeriodBuilder()..Months = 5)
      ..Text = "P5M",
    new Data.builder(new PeriodBuilder()..Weeks = 5)
      ..Text = "P5W",
    new Data.builder(new PeriodBuilder()..Days = 5)
      ..Text = "P5D",
    new Data.builder(new PeriodBuilder()..Hours = 5)
      ..Text = "PT5H",
    new Data.builder(new PeriodBuilder()..Minutes = 5)
      ..Text = "PT5M",
    new Data.builder(new PeriodBuilder()..Seconds = 5)
      ..Text = "PT5S",
    new Data.builder(new PeriodBuilder()..Milliseconds = 5)
      ..Text = "PT5s",
    new Data.builder(new PeriodBuilder()..Ticks = 5)
      ..Text = "PT5t",
    new Data.builder(new PeriodBuilder()..Nanoseconds = 5)
      ..Text = "PT5n",

// No normalization
    new Data.builder(new PeriodBuilder()
      ..Hours = 25
      ..Minutes = 90)
      ..Text = "PT25H90M",

// Compound, negative and zero tests
    new Data.builder(new PeriodBuilder()
      ..Years = 5
      ..Months = 2)
      ..Text = "P5Y2M",
    new Data.builder(new PeriodBuilder()
      ..Months = 1
      ..Hours = 0)
      ..Text = "P1M",
    new Data.builder(new PeriodBuilder()
      ..Months = 1
      ..Minutes = -1)
      ..Text = "P1MT-1M",
    new Data.builder(new PeriodBuilder()
      ..Hours = 1
      ..Minutes = -1)
      ..Text = "PT1H-1M",

// Max/min
    new Data(new Period.fromHours(Utility.int64MaxValue))
      ..Text = "PT9223372036854775807H",
    new Data(new Period.fromHours(Utility.int64MinValue))
      ..Text = "PT-9223372036854775808H",
  ];

  @internal Iterable<Data> get ParseData => [ParseOnlyData, FormatAndParseData].expand((x) => x);

  @internal Iterable<Data> get FormatData => [FormatOnlyData, FormatAndParseData].expand((x) => x);

  @Test()
  void ParseNull() => AssertParseNull(PeriodPattern.Roundtrip);
}
