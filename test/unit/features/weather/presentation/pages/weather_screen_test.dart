import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_event.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_state.dart';
import 'package:weather_app/features/weather/presentation/pages/weather_screen.dart';
import 'package:weather_app/features/weather/presentation/widgets/error_widget.dart';
import 'package:weather_app/features/weather/presentation/widgets/loading_widget.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_info_widget.dart';

import 'weather_screen_test.mocks.dart';

@GenerateMocks([WeatherBloc])
void main() {
  late WeatherBloc mockWeatherBloc;

  setUp(() {
    mockWeatherBloc = MockWeatherBloc();
  });

  Widget buildTestableWidget(Widget widget) {
    return MaterialApp(
      home: BlocProvider<WeatherBloc>.value(
        value: mockWeatherBloc,
        child: widget,
      ),
    );
  }

  testWidgets('renders LoadingWidget on WeatherInitial',
      (WidgetTester tester) async {
    // Arrange
    when(mockWeatherBloc.state).thenReturn(const WeatherInitial());
    when(mockWeatherBloc.stream)
        .thenAnswer((_) => const Stream<WeatherState>.empty());

    // Act
    await tester.pumpWidget(buildTestableWidget(const WeatherScreen()));

    // Assert
    expect(find.byType(LoadingWidget), findsOneWidget);
  });

  testWidgets('renders LoadingWidget on WeatherLoading',
      (WidgetTester tester) async {
    when(mockWeatherBloc.state).thenReturn(const WeatherLoading());
    when(mockWeatherBloc.stream)
        .thenAnswer((_) => const Stream<WeatherState>.empty());

    await tester.pumpWidget(buildTestableWidget(const WeatherScreen()));

    expect(find.byType(LoadingWidget), findsOneWidget);
  });

  testWidgets('renders WeatherDisplay on WeatherLoaded',
      (WidgetTester tester) async {
    const weather = Weather(
      locationName: 'HoChiMinh',
      currentTemperature: 30.0,
      dailyForecasts: [],
    );
    when(mockWeatherBloc.state).thenReturn(const WeatherLoaded(weather));
    when(mockWeatherBloc.stream)
        .thenAnswer((_) => const Stream<WeatherState>.empty());

    await tester.pumpWidget(buildTestableWidget(const WeatherScreen()));

    expect(find.byType(WeatherInfoWidget), findsOneWidget);
    expect(find.textContaining('HoChiMinh'), findsOneWidget);
    expect(find.textContaining('30°'), findsOneWidget);
  });

  testWidgets('renders MessageDisplay on WeatherError',
      (WidgetTester tester) async {
    when(mockWeatherBloc.state)
        .thenReturn(const WeatherError(GeneralFailure()));
    when(mockWeatherBloc.stream)
        .thenAnswer((_) => const Stream<WeatherState>.empty());

    await tester.pumpWidget(buildTestableWidget(const WeatherScreen()));

    expect(find.byType(WeatherErrorWidget), findsOneWidget);
    expect(find.textContaining(const GeneralFailure().defaultDisplayMessage),
        findsOneWidget);
  });

  testWidgets('should show CustomErrorWidget and call FetchWeather on retry',
      (WidgetTester tester) async {
    when(mockWeatherBloc.state)
        .thenReturn(const WeatherError(GeneralFailure()));
    when(mockWeatherBloc.stream)
        .thenAnswer((_) => const Stream<WeatherState>.empty());

    await tester.pumpWidget(buildTestableWidget(const WeatherScreen()));

    expect(find.byType(WeatherErrorWidget), findsOneWidget);

    final retryButtonFinder = find.byKey(const Key('retry_button'));
    expect(retryButtonFinder, findsOneWidget);

    await tester.tap(retryButtonFinder);
    await tester.pump();

    verify(mockWeatherBloc.add(const FetchWeather())).called(1);
  });
}
