import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/presentation/cubit/weather_cubit.dart';
import 'package:weather_app/features/weather/presentation/cubit/weather_state.dart';
import 'package:weather_app/features/weather/presentation/pages/weather_screen.dart';
import 'package:weather_app/features/weather/presentation/widgets/error_widget.dart';
import 'package:weather_app/features/weather/presentation/widgets/loading_widget.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_info_widget.dart';

import 'weather_screen_test.mocks.dart';

@GenerateMocks([WeatherCubit])
void main() {
  late MockWeatherCubit mockWeatherCubit;

  setUp(() {
    mockWeatherCubit = MockWeatherCubit();
  });

  Widget makeTestableWidget(Widget? widget) {
    return MaterialApp(
      home: BlocProvider<WeatherCubit>.value(
        value: mockWeatherCubit,
        child: const WeatherScreen(),
      ),
    );
  }

  testWidgets('should show loading widget when state is loading',
      (WidgetTester tester) async {
    when(mockWeatherCubit.state).thenReturn(const WeatherLoading());
    when(mockWeatherCubit.stream)
        .thenAnswer((_) => Stream.value(const WeatherLoading()));

    await tester.pumpWidget(makeTestableWidget(const WeatherScreen()));

    expect(find.byType(LoadingWidget), findsOneWidget);
  });

  testWidgets('should show weather info when state is loaded',
      (WidgetTester tester) async {
    final weather = Weather(
      currentTemperature: 30.0,
      locationName: 'Ho Chi Minh',
      dailyForecasts: [
        DailyForecast(date: DateTime(2025, 4, 19), avgTemperature: 30.0),
      ],
    );
    when(mockWeatherCubit.state).thenReturn(WeatherLoaded(weather));
    when(mockWeatherCubit.stream)
        .thenAnswer((_) => Stream.value(WeatherLoaded(weather)));

    await tester.pumpWidget(makeTestableWidget(const WeatherScreen()));

    expect(find.byType(WeatherInfoWidget), findsOneWidget);
  });

  testWidgets('should show error widget when state is error',
      (WidgetTester tester) async {
    const failure = GeneralFailure('Something went wrong');
    when(mockWeatherCubit.state).thenReturn(const WeatherError(failure));
    when(mockWeatherCubit.stream)
        .thenAnswer((_) => Stream.value(const WeatherError(failure)));

    await tester.pumpWidget(makeTestableWidget(const WeatherScreen()));

    expect(find.byType(WeatherErrorWidget), findsOneWidget);
  });

  testWidgets('should call fetchWeather when retry button is pressed',
      (WidgetTester tester) async {
    const failure = GeneralFailure('Something went wrong');
    when(mockWeatherCubit.state).thenReturn(const WeatherError(failure));
    when(mockWeatherCubit.stream)
        .thenAnswer((_) => Stream.value(const WeatherError(failure)));

    await tester.pumpWidget(makeTestableWidget(const WeatherScreen()));
    await tester.tap(find.byType(ElevatedButton));

    verify(mockWeatherCubit.fetchWeather()).called(1);
  });
}
