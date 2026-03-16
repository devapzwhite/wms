# Contexto del Proyecto – WMS Taller Mecánico

## Visión general

Estoy desarrollando una aplicación llamada **WMS (Workshop Management System)** para gestionar talleres mecánicos (autos y motos).  
La app es tipo SaaS y multi‑taller: varios talleres usan la misma plataforma, pero cada uno ve solo sus datos, aislados por `shop_id`.

Stack principal:

- Frontend: Flutter (Dart), app móvil, usando Riverpod para state management y go_router para navegación.
- Backend: FastAPI (Python) + PostgreSQL, con SQLAlchemy y migraciones.
- Despliegue objetivo: Render u otro PaaS similar, con entorno `.env`.



# Patrones de desarrollo:
1. Clean Architecture / Feature-First:
   - Estructura por features: features/customers/, features/vehicles/, features/workorders/, features/auth/, features/home/
   - Cada feature tiene: domain/, infrastructure/, presentation/
2. Repository Pattern:
   - Interfaces en domain/repository/
   - Implementaciones en infrastructure/repository/
3. Datasource Pattern:
   - Interfaces en domain/datasource/
   - Implementaciones en infrastructure/datasource/
4. Mappers:
   - Separación en infrastructure/mappers/ para convertir entre entidades y modelos/datos
5. Riverpod:
   - Estado con NotifierProvider
   - Providers para repositorios
6. Go Router para navegación
7. Dio para HTTP client
  

  
## Problema que resuelve

El WMS centraliza la operación diaria del taller:

- Registro de clientes.
- Registro de vehículos (por cliente).
- Creación y gestión de órdenes de trabajo (OT) / reparaciones.
- Control de repuestos e ítems de mano de obra asociados a cada OT.
- Cálculo de costos, precios de venta y ganancias.
- Historial de reparaciones por vehículo y por cliente.
- Soporte multi‑taller por `shop_id`.

## Entidades principales (nivel alto)

- **Shop / Taller**
  - Identificador del taller (`shop_id`).
  - Datos básicos del negocio.

- **User / Empleado**
  - Usuarios internos del sistema.
  - Relación con `shop_id`.
  - Manejan clientes, vehículos y OT.

- **Client / Cliente**
  - Datos de contacto.
  - Puede tener múltiples vehículos.

- **Vehicle / Vehículo**
  - Pertenece a un cliente.
  - Datos básicos del vehículo (marca, modelo, año, tipo, etc.).
  - Relación con el taller vía `shop_id`.

- **WorkOrder / OT (Orden de Trabajo)**
  - Asociada a un vehículo (y por extensión a un cliente).
  - Estados típicos: creado, en diagnóstico, en reparación, finalizado, entregado.
  - Tiene ítems de repuestos y mano de obra.

- **WorkOrderItem / Ítem de OT**
  - Línea de detalle de la OT.
  - Puede ser de tipo “repuesto” o “mano de obra”.
  - Campos típicos: descripción, cantidad, costo unitario, precio unitario, subtotal.

- **Auth**
  - Sistema de autenticación (JWT).
  - Roles básicos: admin de taller y usuarios normales del taller.

## Flujo de uso resumido

1. El usuario del taller inicia sesión en la app.
2. Desde la lista de clientes, selecciona un cliente existente o crea uno nuevo.
3. En el detalle del cliente ve la lista de vehículos asociados.
4. Desde un vehículo puede:
   - Ver historial de OT.
   - Crear una nueva OT para una reparación.
5. En la OT:
   - Agrega ítems de repuestos y mano de obra.
   - Ve los totales de costo, precio y ganancia estimada.
   - Cambia el estado de la OT según el avance del trabajo.
6. Al finalizar la reparación:
   - La OT queda cerrada.
   - El vehículo mantiene el historial completo de reparaciones.

## Objetivo al usar MiniMax

Quiero que actúes como **arquitecto y pair‑programmer full‑stack** para este proyecto WMS con Flutter + FastAPI + PostgreSQL.

Quiero que sigas estas reglas:

1. Respeta este contexto general del sistema (taller mecánico multi‑taller).
2. Usa buenas prácticas de arquitectura y organización de carpetas tanto en backend como en frontend.
3. Explica brevemente cada decisión técnica importante (estructura de módulos, modelos, endpoints, providers, etc.).
4. Genera código orientado a producción (tipado, manejo de errores, validaciones básicas, separación de capas).
5. Siempre que generes código:
   - Indica la ruta de archivo.
   - Muestra el contenido completo del archivo.
6. Cuando te pida nuevas features, primero haz un pequeño diseño/plan (entidades, flujos, pantallas) y luego el código.

## Primera tarea recomendada

Como primer paso, quiero que:

1. Diseñes o revises la estructura de carpetas del backend FastAPI para este WMS.
2. Diseñes o revises la estructura de carpetas del frontend Flutter (features, providers, routing).
3. Propongas mejoras o ajustes si lo ves necesario, manteniendo el enfoque en:
   - Multi‑taller (`shop_id`).
   - Entidades Client, Vehicle, WorkOrder, WorkOrderItem.
   - Extensibilidad futura (por ejemplo: inventario, facturación, roles avanzados).

Cuando estés listo, responde con:

- Un resumen corto de la arquitectura propuesta.
- El árbol de carpetas sugerido (backend y frontend).
- Los archivos base mínimos (por ejemplo, `main.py`, modelos y esquemas principales; pantalla inicial y providers base en Flutter).
