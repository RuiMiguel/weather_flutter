import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:weather/theme/theme.dart';
import 'package:weather/weather/weather.dart';

import '../../helpers/hydrated_bloc.dart';

class MockWeather extends Mock implements Weather {
  MockWeather(this.condition);

  final WeatherCondition condition;
}

void main() {
  group('ThemeCubit', () {
    late ThemeCubit themeCubit;

    setUpAll(initHydratedBloc);

    setUp(() {
      themeCubit = ThemeCubit();
    });

    tearDown(() {
      themeCubit.close();
    });

    test('initial state is correct', () {
      expect(themeCubit.state, ThemeCubit.defaultColor);
    });

    group('toJson/fromJson', () {
      test('works properly', () {
        expect(
          themeCubit.fromJson(themeCubit.toJson(themeCubit.state)),
          themeCubit.state,
        );
      });
    });

    group('updateTheme', () {
      final clearWeather = MockWeather(WeatherCondition.clear);
      final snowyWeather = MockWeather(WeatherCondition.snowy);
      final cloudyWeather = MockWeather(WeatherCondition.cloudy);
      final rainyWeather = MockWeather(WeatherCondition.rainy);
      final unknownWeather = MockWeather(WeatherCondition.unknown);

      blocTest<ThemeCubit, Color>(
        'emits nothing when weather is null',
        build: () => themeCubit,
        act: (cubit) => cubit.updateTheme(null),
        expect: () => <Color>[],
      );

      blocTest<ThemeCubit, Color>(
        'emits correct color for WeatherCondition.clear',
        build: () => ThemeCubit(),
        act: (cubit) => cubit.updateTheme(clearWeather),
        expect: () => <Color>[Colors.orangeAccent],
      );

      blocTest<ThemeCubit, Color>(
        'emits correct color for WeatherCondition.snowy',
        build: () => ThemeCubit(),
        act: (cubit) => cubit.updateTheme(snowyWeather),
        expect: () => <Color>[Colors.lightBlueAccent],
      );

      blocTest<ThemeCubit, Color>(
        'emits correct color for WeatherCondition.cloudy',
        build: () => ThemeCubit(),
        act: (cubit) => cubit.updateTheme(cloudyWeather),
        expect: () => <Color>[Colors.blueGrey],
      );

      blocTest<ThemeCubit, Color>(
        'emits correct color for WeatherCondition.rainy',
        build: () => ThemeCubit(),
        act: (cubit) => cubit.updateTheme(rainyWeather),
        expect: () => <Color>[Colors.indigoAccent],
      );

      blocTest<ThemeCubit, Color>(
        'emits correct color for WeatherCondition.unknown',
        build: () => ThemeCubit(),
        act: (cubit) => cubit.updateTheme(unknownWeather),
        expect: () => <Color>[ThemeCubit.defaultColor],
      );
    });
  });
}
