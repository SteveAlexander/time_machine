// https://github.com/nodatime/nodatime/blob/master/src/NodaTime/Calendars/Era.cs
// 69dedbc  24 days ago

import 'dart:async';
import 'dart:math' as math;
import 'dart:mirrors';

import 'package:time_machine/time_machine.dart';
import 'package:time_machine/time_machine_calendars.dart';
import 'package:time_machine/time_machine_utilities.dart';

import 'package:test/test.dart';
import 'package:matcher/matcher.dart';
import 'package:time_machine/time_machine_timezones.dart';

import '../time_machine_testing.dart';

Future main() async {
  var eraType = reflectType(Era) as ClassMirror;
  Eras = eraType
      .declarations
      .values
      .where((v) => v is VariableMirror && v.isStatic)
      .map((v) => eraType.getField(v.simpleName).reflectee)
      .toList();

  await runTests();
}

List<Era> Eras = []; /*typeof(Era).GetTypeInfo()
    .DeclaredProperties // TODO: Only static and ones...
    .Where(property => property.PropertyType == typeof(Era))
.Select(property => property.GetValue(null, null))
.Cast<Era>();*/

@TestCaseSource(#Eras)
@Test() @SkipMe.unimplemented()
void ResourcePresence(Era era)
{
  // todo: get us resources?
  var valueByName = null; // PatternResources.ResourceManager.GetString(era.ResourceIdentifier, CultureInfo.InvariantCulture);
  expect(valueByName, isNotNull, reason: "Missing resource for " + era?.resourceIdentifier ?? 'null');
}