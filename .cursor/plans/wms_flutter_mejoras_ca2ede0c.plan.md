---
name: WMS Flutter mejoras
overview: "Plan de mejoras para alinear el frontend Flutter del WMS con la visión de sistema completo multi-taller: navegación, pantalla de detalle de OT, formulario de edición de OT funcional, flujo cliente → vehículo → OT, y coherencia con el backend."
todos: []
isProject: false
---

# Plan de mejoras – WMS Flutter (Taller Mecánico)

## Estado actual resumido

- **Auth**: Login + JWT + `KeyValueStorageService` (SharedPreferences). Multi-tenant por `shop_id` en sesión.
- **Clientes**: CRUD completo, lista → detalle (con vehículos) → “Editar vehículo” / “Crear Orden” / tap → detalle vehículo.
- **Vehículos**: CRUD completo, detalle con historial de OT desde `GET /vehicles/{id}/workorders`.
- **Órdenes de trabajo (OT)**:
  - Crear OT: desde vehículo o desde detalle de cliente; formulario con diagnóstico, notas, estado e ítems (diálogo para diagnóstico/mano de obra/pieza, cantidad, precio). FAB para agregar ítems. Envío con `workorder_items`.
  - **Editar OT**: pantalla presente pero formulario no conectado (handlers vacíos).
  - **Detalle OT (solo lectura)**: no existe pantalla ni ruta; el provider `work_order_detail_providers.dart` existe pero `_loadData()` está vacío.
- **Router**: Definición real en [lib/config/router/app_router_provider.dart](lib/config/router/app_router_provider.dart). [lib/config/router/app_router.dart](lib/config/router/app_router.dart) está obsoleto (solo 3 rutas).
- **Backend**: Repo separado (`workshops_api`). Documentación local en [docs/endpoints.md](docs/endpoints.md). Flutter usa `GET /workorders/?id=` para detalle; creación envía `workorder_items` (confirmar contrato con backend).

---

## 1. Navegación y rutas

### 1.1 Pantalla de detalle de OT (solo lectura)

- **Problema**: No hay forma de “ver” una OT sin entrar a editar. En detalle de vehículo solo hay “Editar” y “cambiar de estado” (sin acción).
- **Acción**:
  - Añadir ruta en [app_router_provider.dart](lib/config/router/app_router_provider.dart): p.ej. `path: 'detailworkorder/:id_workorder'` bajo `/workorders`, builder que reciba `id_workorder` y muestre `WorkOrderDetailScreen(idWorkOrder: id)`.
  - Crear **WorkOrderDetailScreen** (solo lectura): título (vehículo/patente), estado, diagnóstico, notas, fechas, lista de ítems (tipo, descripción, cantidad, precio). Usar `workOrderNotifierProvider(workOrderId)`.
  - Implementar **WorkOrderDetailNotifier._loadData()**: llamar a `ref.read(workOrderRepositoryProvider).getWorkOrderDetail(workOrderId)` y actualizar estado (ya existe `getWorkOrderDetail` en datasource/repository).
  - En **VehicleDetailsScreen**: hacer que el tap en la card de la OT navegue a la nueva ruta de detalle (y opcionalmente mantener “Editar” como botón secundario).

### 1.2 Menú de órdenes y “Agregar Orden”

- **Problema**: El ítem del menú “Agregar Orden” hace `context.push('/workorders/addworkorder')`, pero la ruta definida es `addworkorder/:id_vehicle`. Sin `id_vehicle` la ruta no coincide y la navegación falla.
- **Opciones**:
  - **A (recomendada)**: Quitar “Agregar Orden” del menú de work orders y dejar solo “Listar” o “Ver órdenes” que lleve a una pantalla lista de OT del taller (si el backend ofrece `GET /workorders/` sin filtro). Crear OT solo desde detalle de cliente (por vehículo) o desde detalle de vehículo.
  - **B**: Añadir flujo “Seleccionar vehículo” desde el menú: pantalla que liste vehículos del taller y al elegir uno navegue a `addworkorder/:id_vehicle`.

### 1.3 Router obsoleto

- Eliminar o dejar de usar [app_router.dart](lib/config/router/app_router.dart) para evitar confusión (el que se usa en producción es el de `app_router_provider.dart`).

---

## 2. Órdenes de trabajo – formulario de edición

- **Problema**: [UpdateWorkOrderScreen](lib/features/workorders/presentation/screens/update_work_order_screen.dart) tiene dropdown de estado y campos de diagnóstico/observaciones con `onSelected: () {}` y `onChanged: (value) {}` vacíos; no carga datos de la OT.
- **Acción**:
  - Cargar la OT al entrar: en `initState` o en un provider, llamar a `getWorkOrderDetail(idWorkOrder)` y rellenar controles (estado, diagnóstico, notas).
  - Conectar dropdown de estado y los `CustomLargeTextFormField` al estado (provider de formulario de edición o reutilizar lógica de form) y al enviar llamar a `PUT /workorders/{id}` con el payload de actualización.
  - Opcional: permitir en la misma pantalla agregar/editar/eliminar ítems si el backend lo soporta (depende del contrato de `PUT /workorders/{id}`).

---

## 3. “Cambiar de estado” en detalle de vehículo

- **Problema**: El botón “cambiar de estado” en cada OT en [VehicleDetailsScreen](lib/features/vehicles/presentation/screens/vehicle_details_screen.dart) tiene `onTap: () {}`.
- **Acción**:
  - Opción simple: navegar a la pantalla de edición de OT con ese `workOrder.id` (ya tienes “Editar” que hace eso; se puede unificar el texto a “Editar / Cambiar estado” y un solo botón).
  - Opción más rica: abrir un bottom sheet o diálogo con los estados permitidos (usar `WorkStatus`) y al elegir llamar a `PUT /workorders/{id}` solo con el nuevo `status`, luego invalidar el provider del detalle del vehículo para refrescar la lista de OT.

---

## 4. Consistencia de nombres y limpieza

- **Vehicles**: El repository de dominio es [vehicles_repository.dart](lib/features/vehicles/domain/repository/vehicles_repository.dart) (plural) y la implementación [vehicle_repository.dart](lib/features/vehicles/infrastructure/repository/vehicle_repository.dart) (singular). Funciona; si se quiere homogeneizar, alinear nombres (p.ej. `vehicles_repository_impl.dart`) en una pasada de refactor.
- **Work orders**: [workorders_screens.dart](lib/features/workorders/presentation/screens/workorders_screens.dart) no exporta `UpdateWorkOrderScreen`; el router lo importa desde el archivo concreto. Opcional: exportar en el barrel para consistencia con customers/vehicles.
- **Variable en router**: En [app_router_provider.dart](lib/config/router/app_router_provider.dart) en la ruta `updateworkorder/:id_workorder` se usa una variable local llamada `idVehiculo` para el id de la OT; renombrar a `idWorkOrder` para legibilidad.

---

## 5. Backend y contratos

- **POST /workorders/** en [docs/endpoints.md](docs/endpoints.md) muestra body con `vehicle_id`, `customer_id`, `description`, `status`. El mapper en Flutter envía además `workorder_items`. Confirmar en el backend que el schema de creación acepta `workorder_items`; si no, definir si ítems se crean en otro endpoint o en un PUT posterior.
- **Payload de actualización**: Documentar en `docs/endpoints.md` el body exacto de `PUT /workorders/{id}` (status, initial_diagnosis, notes, ítems si aplica) para que el formulario de edición envíe lo correcto.
- **Status_logs**: Si en el futuro se quiere historial de cambios de estado en la app, el backend ya tiene la tabla; faltaría un endpoint (p.ej. `GET /workorders/{id}/status_logs`) y una entidad/UI en Flutter. Dejarlo como mejora futura.

---

## 6. Mejoras opcionales (no bloqueantes)

- **Cálculo de costos/ganancias**: Las entidades tienen `laborEstimate`, `partsEstimate` y en ítems `unitCost`/`unitPrice`. Si el backend ya devuelve totales o se calculan en front, mostrar en detalle de OT un resumen (subtotal mano de obra, repuestos, total).
- **Fotos (before/after)**: `WorkOrderItem` tiene `beforePhoto`/`afterPhoto`; en mappers están comentados. Cuando el backend soporte subida/URL, descomentar y añadir campos en el diálogo de ítem y en la pantalla de detalle de OT.
- **Lista global de OT**: Si se quiere “Ver todas las órdenes” desde el menú, una pantalla que consuma `GET /workorders/` (lista) con filtros por estado y enlace a detalle/edición.
- **Tests**: Mantener y ampliar tests de mappers y providers según [CLAUDE.md](CLAUDE.md); añadir tests para nuevos providers (p.ej. `WorkOrderDetailNotifier` cuando esté implementado).

---

## Orden sugerido de implementación

1. **Detalle de OT**: ruta + `WorkOrderDetailScreen` + implementar `_loadData()` en `WorkOrderDetailNotifier` y enlace desde detalle de vehículo.
2. **Menú work orders**: ajustar (quitar “Agregar” o añadir flujo “elegir vehículo”) y, si aplica, pantalla lista de OT.
3. **Edición de OT**: cargar datos en `UpdateWorkOrderScreen` y conectar formulario a `PUT /workorders/{id}`.
4. **“Cambiar de estado”**: unificar con “Editar” o implementar diálogo/bottom sheet + PUT.
5. **Limpieza**: router obsoleto, nombres de variables/archivos, barrel exports.
6. **Documentación y backend**: alinear `docs/endpoints.md` con el contrato real y soporte de `workorder_items` / PUT.

Con esto el flujo **cliente → vehículos del cliente → detalle vehículo → historial de OT → ver detalle OT / editar OT / crear OT** queda completo y alineado con la visión de WMS multi-taller.