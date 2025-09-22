// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';

import 'package:historico_precos/main.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    // Set a larger screen size to avoid overflow issues
    await tester.binding.setSurfaceSize(const Size(800, 1200));

    await tester.pumpWidget(const HistoricoPrecos());
    expect(find.text('Histórico de Preços'), findsOneWidget);

    // Reset surface size
    await tester.binding.setSurfaceSize(null);
  });
}
