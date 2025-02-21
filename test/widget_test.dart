import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notas_app/main.dart'; // Asegúrate de que el nombre del paquete es correcto

void main() {
  testWidgets('Agregar y eliminar una nota', (WidgetTester tester) async {
    // Construir la aplicación
    await tester.pumpWidget(NotasApp());

    // Verificar que la lista de notas está vacía al inicio
    expect(find.byType(ListTile), findsNothing);

    // Abrir el formulario de agregar nota
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Ingresar título y contenido
    await tester.enterText(find.byType(TextField).at(0), 'Nota de prueba');
    await tester.enterText(find.byType(TextField).at(1), 'Contenido de la nota');

    // Guardar la nota
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    // Verificar que la nota ha sido agregada
    expect(find.text('Nota de prueba'), findsOneWidget);
    expect(find.text('Contenido de la nota'), findsOneWidget);

    // Eliminar la nota
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // Verificar que la nota ha sido eliminada
    expect(find.text('Nota de prueba'), findsNothing);
  });
}
