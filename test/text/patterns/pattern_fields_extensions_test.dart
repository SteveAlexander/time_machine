// https://github.com/nodatime/nodatime/blob/master/src/NodaTime.Test/Text/Patterns/PatternFieldsExtensionsTest.cs
// 8d5399d  on Feb 26, 2016

import 'dart:async';
import 'dart:math' as math;
import 'dart:mirrors';

import 'package:time_machine/time_machine.dart';
import 'package:time_machine/time_machine_calendars.dart';
import 'package:time_machine/time_machine_patterns.dart';
import 'package:time_machine/time_machine_text.dart';
import 'package:time_machine/time_machine_utilities.dart';

import 'package:test/test.dart';
import 'package:matcher/matcher.dart';
import 'package:time_machine/time_machine_timezones.dart';

import '../../time_machine_testing.dart';
import '../text_cursor_test_base_tests.dart';

Future main() async {
  await runTests();
}

@Test()
void IsUsed_NoMatch()
{
  expect((PatternFields.hours12 | PatternFields.minutes).HasAny(PatternFields.hours24), isFalse);
}

@Test()
void IsUsed_SingleValueMatch()
{
  expect(PatternFields.hours24.HasAny(PatternFields.hours24), isTrue);
}

@Test()
void IsFieldUsed_MultiValueMatch()
{
  expect((PatternFields.hours24 | PatternFields.minutes).HasAny(PatternFields.hours24), isTrue);
}

@Test()
void AllAreUsed_NoMatch()
{
  expect((PatternFields.hours12 | PatternFields.minutes).HasAll(PatternFields.hours24 | PatternFields.seconds), isFalse);
}

@Test()
void AllAreUsed_PartialMatch()
{
  expect((PatternFields.hours12 | PatternFields.minutes).HasAll(PatternFields.hours12 | PatternFields.seconds), isFalse);
}

@Test()
void AllAreUsed_CompleteMatch()
{
  expect((PatternFields.hours12 | PatternFields.minutes).HasAll(PatternFields.hours12 | PatternFields.minutes), isTrue);
}

@Test()
void AllAreUsed_CompleteMatchWithMore()
{
  expect((PatternFields.hours24 | PatternFields.minutes | PatternFields.hours12).HasAll(PatternFields.hours24 | PatternFields.minutes), isTrue);
}