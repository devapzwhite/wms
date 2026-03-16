# PLAN DE MEJORAS - WMS Flutter (15/03)

## RESUMEN EJECUTIVO

Se ha analizado todo el proyecto Flutter (frontend) y la documentación del backend. El proyecto tiene una **buena arquitectura basada en features** con Clean Architecture, pero existen varias funcionalidades incompletas y áreas de mejora.

---

## 1. ESTADO ACTUAL DEL PROYECTO

### ✅ Lo que está implementado:

- **Autenticación**: Login con JWT, manejo de sesión, almacenamiento en SharedPreferences
- **Gestión de Clientes**: CRUD completo con búsqueda por documento
- **Gestión de Vehículos**: CRUD completo con búsqueda por placa
- **Órdenes de Trabajo (OT)**: 
  - Creación de OT con ítems
  - Listado de OTs
  - Endpoint de detalle (sin pantalla completa)
- **Pantalla Home**: Estadísticas del taller
- **Navegación**: go_router con rutas definidas

### ❌ Lo que falta o está incompleto:

| Módulo | Funcionalidad | Estado |
|--------|--------------|--------|
| WorkOrders | Pantalla de detalle (solo lectura) | ❌ No existe |
| WorkOrders | Formulario de edición (Update) | ⚠️ Incompleto - sin conexión a backend |
| WorkOrders | Cambiar estado desde detalle vehículo | ❌ Vacío (onTap vacío) |
| WorkOrders | Lista global de OTs | ⚠️ Solo hay menú, sin pantalla |
| WorkOrders | Items de OT (agregar/editar/eliminar) | ⚠️ Solo en creación |
| Router | "Agregar Orden" del menú | ❌ Navegación rota |
| Home | Stats - filtros por estado | ⚠️ Solo cuenta OPEN/COMPLETED |
| Backend | Endpoints de items por OT | ❌ No implementados |

---

## 2. PRIORIDADES DE MEJORA

### 🔴 PRIORIDAD ALTA (Crítico - Bloquea flujo principal)

#### 2.1 (COMPLETADO) Pantalla de Detalle de Orden de Trabajo

**Problema**: No existe forma de ver una OT sin entrar a editarla.

**Solución**:
- Crear `WorkOrderDetailScreen` en `lib/features/workorders/presentation/screens/`
- Implementar carga de datos usando `WorkOrderDetailNotifier`
- Mostrar: vehículo, estado, diagnóstico, notas, fechas, lista de ítems
- Ruta: `/workorders/detailworkorder/:id_workorder`

**Estado**: ✅ COMPLETADO

#### 2.2 (COMPLETADO) Formulario de Edición de OT (UpdateWorkOrderScreen)

**Problema**: La pantalla existe pero:
- No carga los datos de la OT al iniciar
- Los `onChanged` y `onSelected` están vacíos
- El botón "Guardar" no hace nada

**Solución**:
1. En `initState`, cargar la OT mediante `getWorkOrderDetail(idWorkOrder)`
2. Conectar los controles al estado del formulario
3. Implementar `PUT /workorders/{id}` al presionar guardar
4. Agregar validación de campos

**Archivos a modificar**:
- `lib/features/workorders/presentation/screens/update_work_order_screen.dart`
- Crear provider: `lib/features/workorders/presentation/providers/update_work_order_provider.dart`

#### 2.3 Navegación "Agregar Orden" del Menú

**Problema**: El menú tiene "Agregar Orden" pero la ruta requiere `:id_vehicle` - falla la navegación.

**Solución recomendada**:
- Opción A: Eliminar "Agregar Orden" del menú de workorders (dejar solo "Listar")
- Opción B: Crear pantalla intermedia "Seleccionar Vehículo"
- Opción C: Redirigir a lista de clientes para seleccionar vehículo

---

### 🟡 PRIORIDAD MEDIA (Mejora funcional)

#### 2.4 Cambiar Estado de OT desde Detalle de Vehículo

**Problema**: El botón "cambiar de estado" en cada OT de VehicleDetailsScreen tiene `onTap: () {}`.

**Solución**:
- Opción simple: Unificar con botón "Editar" (que ya navega a UpdateWorkOrderScreen)
- Opción completa: BottomSheet con dropdown de estados + PUT /workorders/{id}

**Archivo a modificar**:
- `lib/features/vehicles/presentation/screens/vehicle_details_screen.dart`

#### 2.5 Mejora de Stats en Home

**Problema**: Solo cuenta OPEN y COMPLETED, no hay desglose por estado.

**Solución**:
- Mostrar todos los estados con su conteo
- Usar `WorkStatus.values` para iterar
- Mejorar visualización (chips o lista)

**Archivo a modificar**:
- `lib/features/home/presentation/widgets/home_stats_widget.dart`
- `lib/features/home/presentation/providers/home_stats_provider.dart`

#### 2.6 Gestión de Ítems de OT

**Problema**: Solo se pueden agregar ítems al crear OT, no al editar.

**Solución**:
- En UpdateWorkOrderScreen, permitir agregar/editar/eliminar ítems
- Verificar si backend soporta PUT con items o requiere endpoint separado

---

### 🟢 PRIORIDAD BAJA (Limpieza y refactor)

#### 2.7 Consistencia de Nombres

- Repository de vehicles: `vehicles_repository.dart` vs `vehicle_repository.dart` (plural/singular inconsistente)
- En router: variable `idVehiculo` para ID de OT (debería ser `idWorkOrder`)

#### 2.8 Limpieza de Código

- Eliminar `lib/config/router/app_router.dart` (obsoleto)
- Exportar `UpdateWorkOrderScreen` en `workorders_screens.dart` (barrel)
- Comentar código muerto en UpdateWorkOrderScreen

#### 2.9 Documentación

- Actualizar `docs/endpoints.md` con payload de PUT /workorders/{id}
- Confirmar contrato de workorder_items en creación

---

## 3. ENDPOINTS FALTANTES DEL BACKEND

Según el análisis del código, el frontend necesita estos endpoints que no están en la documentación:

| Endpoint Necesario | Uso |
|-------------------|-----|
| `PUT /workorders/{id}` | Actualizar OT (estado, diagnóstico, notas) |
| `GET /workorders/{id}/items` | Obtener ítems de una OT |
| `POST /workorders/{id}/items` | Agregar ítem a OT |
| `PUT /workorders/{id}/items/{itemId}` | Actualizar ítem |
| `DELETE /workorders/{id}/items/{itemId}` | Eliminar ítem |
| `GET /workorders/stats` | Stats por estado (evitar 3 llamadas) |

---

## 4. PROPUESTA DE ESTRUCTURA DE ARCHIVOS NUEVOS

```
lib/features/workorders/
├── presentation/
│   ├── providers/
│   │   ├── update_work_order_provider.dart  (NUEVO)
│   │   └── work_order_items_provider.dart   (NUEVO)
│   └── screens/
│       └── work_order_detail_screen.dart     (COMPLETAR)
```

---

## 5. ORDEN SUGERIDO DE IMPLEMENTACIÓN

1. **Semana 1**: Completar WorkOrderDetailScreen + conexión con provider
2. **Semana 2**: Completar UpdateWorkOrderScreen (carga + guardado)
3. **Semana 3**: Fix navegación "Agregar Orden" + cambiar estado
4. **Semana 4**: Mejora de stats en Home + limpieza de código

---

## 6. CONSIDERACIONES TÉCNICAS

### Manejo de Errores
- Los datasource ya tienen manejo de errores básico
- Mejorar: mostrar SnackBar con mensajes amigables
- Agregar retry automático en caso de error de red

### State Management
- Ya usa Riverpod correctamente
- Considerar usar `AsyncValue` para manejo de estados de carga

### Validaciones
- Agregar validaciones en formularios (required, formato email, etc.)
- Usar formz o validators existentes

---

## 7. LISTA DE TAREAS (TODO)

- [ ] Completar WorkOrderDetailScreen con _loadData()
- [ ] Crear UpdateWorkOrderProvider con carga y guardado
- [ ] Conectar UpdateWorkOrderScreen al provider
- [ ] Fix navegación "Agregar Orden"
- [ ] Implementar cambio de estado rápido
- [ ] Mejorar HomeStats con todos los estados
- [ ] Limpiar código muerto
- [ ] Actualizar docs/endpoints.md