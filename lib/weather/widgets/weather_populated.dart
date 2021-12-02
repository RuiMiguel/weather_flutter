import 'package:flutter/material.dart';
import 'package:weather/weather/models/weather.dart';

class WeatherPopulated extends StatelessWidget {
  const WeatherPopulated({
    Key? key,
    required this.weather,
    required this.units,
    required this.onRefresh,
  }) : super(key: key);

  final Weather weather;
  final TemperatureUnits units;
  final ValueGetter<Future<void>> onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            clipBehavior: Clip.none,
            child: Column(
              children: [
                const SizedBox(height: 48),
                Text(
                  weather.location,
                  style: theme.textTheme.headline2?.copyWith(
                    fontWeight: FontWeight.w200,
                  ),
                ),
                Text(
                  '',
                  style: theme.textTheme.headline3?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '''Last Update at ${TimeOfDay.fromDateTime(weather.lastUpdated).format(context)}''',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
