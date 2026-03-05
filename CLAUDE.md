# Proyecto WMS – Taller Mecánico

## Resumen

Este repositorio contiene un sistema de gestión de taller mecánico (WMS):

- Backend: FastAPI + PostgreSQL para gestionar clientes, vehículos y órdenes de trabajo
- Frontend: Flutter (app móvil / escritorio) para uso en el taller.

Tu objetivo como asistente es:

- Mantener el código limpio, testeable y consistente.
- Minimizar cambios innecesarios.
- Explicar claramente lo que haces antes de aplicar cambios grandes.

## Tech stack

### Backend

- Framework: FastAPI (Python 3.x)
- ORM: SQLAlchemy
- BD: PostgreSQL
- Tests: pytest

### Frontend

- Framework: Flutter
- Arquitectura: separación por features (features/customers, features/vehicles, etc.)
- State management: Riverpod (si no estás seguro, pregunta antes de asumir)
- Tests: `package:test` y `flutter_test`

## Comandos importantes

### Frontend (Flutter)

- Instalar deps: `flutter pub get`
- Tests de todo el proyecto: `flutter test`
- Test de un archivo concreto: `flutter test <ruta_del_test.dart>`

## Estructura de carpetas (resumen)

- `backend/` – código FastAPI (routers, models, services, repositories)
- `Flutter/wms/` – app Flutter
  - `lib/features/customers/` – clientes
    - `domain/` – entidades y lógica de dominio
    - `infrastructure/mappers/` – mappers como `customer_mappers.dart`
  - `lib/features/vehicles/` – vehículos
  - `test/` – tests de Dart/Flutter

Si la estructura cambia, primero actualiza esta sección antes de asumir.

## Reglas para escribir código

1. **Dart/Flutter**
   - Usa nombres claros en inglés para clases y métodos, pero permite textos en español para la UI.
   - Prefiere funciones puras y mappers pequeños (como `CustomerMappers`) antes que lógica mezclada en widgets.
   - Evita introducir dependencias nuevas sin preguntar.

2. **Tests**
   - Para Dart:
     - Usa `package:test/test.dart` para lógica pura.
     - Usa `flutter_test` solo para widgets.
   - Los nombres de los tests deben describir el comportamiento esperado.

3. **FastAPI**
   - Mantén routers finos; mueve lógica de negocio a servicios/repositorios.
   - Maneja errores con HTTPException y mensajes claros.

## Cómo quiero que trabajes

- Antes de hacer cambios grandes:
  - Resume lo que entendiste del archivo o módulo.
  - Propón un plan corto (lista de pasos) y espera confirmación.
- Cuando generes tests:
  - Explica brevemente qué casos cubre cada `test(...)`.
- Cuando trabajes con mappers (como `CustomerMappers`):
  - Asegúrate de cubrir en tests:
    - manejo de `null` y strings vacíos
    - valores por defecto razonables (ej. `'no email'`, `'no address'`)

## Preferencias específicas para este proyecto

- Para mappers de clientes:
  - En creación (`customerEntityToData`), convierte `''` a `null` para `email` y `address`.
  - En actualización (`customerUpdateEntityToData`), elimina del Map las claves cuyo valor sea `''` o `null`.
  - En lectura (`dataToCustomerEntity`), usa `'no email'` y `'no address'` como valores por defecto si vienen `null`.

- Cuando generes o modifiques tests:
  - Siempre ubica los archivos de tests en `test/`.
  - Usa nombres de archivo con sufijo `_test.dart`.
