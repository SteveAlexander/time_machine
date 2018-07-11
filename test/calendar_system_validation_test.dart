// Portions of this work are Copyright 2018 The Time Machine Authors. All rights reserved.
// Portions of this work are Copyright 2018 The Noda Time Authors. All rights reserved.
// Use of this source code is governed by the Apache License 2.0, as found in the LICENSE.txt file.
import 'dart:async';

import 'package:time_machine/src/time_machine_internal.dart';

import 'time_machine_testing.dart';

Future main() async {
  await runTests();
}

final CalendarSystem Iso = CalendarSystem.iso;

@Test()
@TestCase(const [-9998])
@TestCase(const [9999])
void GetMonthsInYear_Valid(int year)
{
  // note: Dart should be able to infer the types here? But 2.0.0-dev.63.0 is not.
  TestHelper.AssertValid<int, int>(Iso.getMonthsInYear, year);
}

@Test()
@TestCase(const [-9999])
@TestCase(const [10000])
void GetMonthsInYear_Invalid(int year)
{
  TestHelper.AssertOutOfRange<int, int>(Iso.getMonthsInYear, year);
}

@Test()
@TestCase(const [-9998, 1])
@TestCase(const [9999, 12])
void GetDaysInMonth_Valid(int year, int month)
{
  TestHelper.AssertValid2<int, int, int>(Iso.getDaysInMonth, year, month);
}

@Test()
@TestCase(const [-9999, 1])
@TestCase(const [1, 0])
@TestCase(const [1, 13])
@TestCase(const [10000, 1])
void GetDaysInMonth_Invalid(int year, int month)
{
  TestHelper.AssertOutOfRange2<int, int, int>(Iso.getDaysInMonth, year, month);
}

@Test()
void GetDaysInMonth_Hebrew()
{
  TestHelper.AssertValid2<int, int, int>(CalendarSystem.hebrewCivil.getDaysInMonth, 5402, 13); // Leap year
  TestHelper.AssertOutOfRange2<int, int, int>(CalendarSystem.hebrewCivil.getDaysInMonth, 5401, 13); // Not a leap year
}

@Test()
@TestCase(const [-9998])
@TestCase(const [9999])
void IsLeapYear_Valid(int year)
{
  TestHelper.AssertValid<int, bool>(Iso.isLeapYear, year);
}

@Test()
@TestCase(const [-9999])
@TestCase(const [10000])
void IsLeapYear_Invalid(int year)
{
  TestHelper.AssertOutOfRange<int, bool>(Iso.isLeapYear, year);
}

@Test()
@TestCase(const [1])
@TestCase(const [9999])
void GetAbsoluteYear_ValidCe(int year)
{
  TestHelper.AssertValid2<int, Era, int>(Iso.getAbsoluteYear, year, Era.common);
}

@Test() 
@TestCase(const [1])
@TestCase(const [9999])
void GetAbsoluteYear_ValidBce(int year)
{
  TestHelper.AssertValid2<int, Era, int>(Iso.getAbsoluteYear, year, Era.beforeCommon);
}

@Test() 
@TestCase(const [0])
@TestCase(const [10000])
void GetAbsoluteYear_InvalidCe(int year)
{
  TestHelper.AssertOutOfRange2<int, Era, int>(Iso.getAbsoluteYear, year, Era.common);
}

@Test()
@TestCase(const [0])
@TestCase(const [10000])
void GetAbsoluteYear_InvalidBce(int year)
{
  TestHelper.AssertOutOfRange2<int, Era, int>(Iso.getAbsoluteYear, year, Era.beforeCommon);
}

@Test()
void GetAbsoluteYear_InvalidEra()
{
  TestHelper.AssertInvalid2<int, Era, int>(Iso.getAbsoluteYear, 1, Era.annoPersico);
}

@Test()
void GetAbsoluteYear_NullEra()
{
  Era i = null;
  TestHelper.AssertArgumentNull2<int, Era, int>(Iso.getAbsoluteYear, 1, i);
}

@Test()
void GetMinYearOfEra_NullEra()
{
  Era i = null;
  TestHelper.AssertArgumentNull<Era, int>(Iso.getMinYearOfEra, i);
}

@Test()
void GetMinYearOfEra_InvalidEra()
{
  TestHelper.AssertInvalid<Era, int>(Iso.getMinYearOfEra, Era.annoPersico);
}

@Test()
void GetMaxYearOfEra_NullEra()
{
  Era i = null;
  TestHelper.AssertArgumentNull<Era, int>(Iso.getMaxYearOfEra, i);
}

@Test()
void GetMaxYearOfEra_InvalidEra()
{
  TestHelper.AssertInvalid<Era, int>(Iso.getMaxYearOfEra, Era.annoPersico);
}
