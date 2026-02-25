# WMS — Workshop Management System

<p align="center">
  <img src="assets/icons/app_icon.png" alt="WMS Logo" width="120"/>
</p>

<p align="center">
  <strong>Sistema de gestión integral para talleres mecánicos</strong><br/>
  Registra clientes, vehículos, diagnósticos y órdenes de trabajo desde tu celular.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.29.3-02569B?logo=flutter" />
  <img src="https://img.shields.io/badge/Dart-3.10.4-0175C2?logo=dart" />
  <img src="https://img.shields.io/badge/Platform-Android-3DDC84?logo=android" />
  <img src="https://img.shields.io/badge/Backend-FastAPI-009688?logo=fastapi" />
  <img src="https://img.shields.io/badge/State-Riverpod-blue" />
  <img src="https://img.shields.io/badge/Version-0.1.0-lightgrey" />
</p>

---

## 📋 Descripción

**WMS (Workshop Management System)** es una aplicación móvil Android desarrollada en Flutter para la gestión integral de talleres mecánicos. Permite registrar el proceso completo de reparación de vehículos: desde el alta de clientes y vehículos hasta la creación, seguimiento y cierre de órdenes de trabajo con diagnósticos, costos y fotos.

Está diseñada como sistema **multi-taller**: cada usuario solo accede a los datos de su propio taller (`shop_id`), lo que permite que múltiples talleres compartan la misma API sin mezclar información.

---

## ✨ Features principales

- 🔐 **Autenticación JWT** — Login con sesión persistente en `SharedPreferences`
- 👥 **Gestión de Clientes** — Registro, edición y detalle de clientes con datos de contacto
- 🚗 **Gestión de Vehículos** — Registro de vehículos asociados a clientes (marca, modelo, año, patente, KM)
- 📋 **Órdenes de Trabajo** — Creación y seguimiento del ciclo completo de reparación
- 🔧 **Ítems de trabajo** — Registro de diagnósticos, piezas, mano de obra y costos por ítem
- 📸 **Fotos antes/después** — Registro visual del estado del vehículo
- 📊 **Estado de OT** — Trazabilidad del estado: `RECEIVED → IN_PROGRESS → COMPLETED`
- 🏠 **Panel principal** — Vista resumen del estado del taller
- 🌐 **Multi-taller** — Arquitectura multi-tenant con aislamiento por `shop_id`

> ⚠️ **Roles de usuario**: planificados para una próxima versión. Actualmente todos los usuarios autenticados tienen el mismo nivel de acceso.

---

## 🛠️ Stack Técnico

| Capa                 | Tecnología           | Versión         |
| -------------------- | -------------------- | --------------- |
| UI / Mobile          | Flutter              | 3.29.3          |
| Lenguaje             | Dart                 | 3.10.4          |
| State Management     | Riverpod             | 3.2.1           |
| Navegación           | Go Router            | 17.1.0          |
| HTTP Client          | Dio                  | 5.9.1           |
| Formularios          | Formz                | 0.8.0           |
| Almacenamiento local | Shared Preferences   | 2.5.4           |
| Variables de entorno | Flutter Dotenv       | 6.0.0           |
| Links externos       | URL Launcher         | 6.3.2           |
| Backend              | FastAPI + PostgreSQL | (repo separado) |
| Autenticación        | JWT (Bearer Token)   | —               |

---

## 🏗️ Arquitectura

El proyecto implementa **Clean Architecture** organizada por features (feature-first). Cada feature tiene sus propias capas: `domain`, `infrastructure` y `presentation`, evitando acoplamiento entre módulos.

```
lib/
├── config/                          # Configuración global (router, theme, env)
├── domain/                          # Entidades y contratos globales compartidos
│
├── features/
│   ├── auth/                        # Autenticación (login, JWT, sesión)
│   ├── customers/                   # Gestión de clientes
│   │   ├── domain/
│   │   │   ├── datasource/          # Contratos abstractos de datos
│   │   │   ├── entity/              # Entidades del dominio
│   │   │   └── repository/          # Contratos del repositorio
│   │   ├── infrastructure/
│   │   │   ├── datasource/          # Implementaciones (llamadas a API)
│   │   │   ├── mappers/             # Mapeo JSON ↔ Entity
│   │   │   └── repository/          # Implementaciones del repositorio
│   │   └── presentation/
│   │       ├── providers/           # Providers de Riverpod
│   │       ├── screens/             # Pantallas
│   │       └── widgets/             # Widgets reutilizables del feature
│   ├── home/                        # Pantalla principal del taller
│   ├── vehicles/                    # Gestión de vehículos
│   └── workorders/                  # Órdenes de trabajo
│
├── infrastructure/
│   └── datasource/services/
│       └── key_value_storage_services.dart   # Abstracción SharedPreferences
│
└── presentation/
    ├── inputs/                      # Clases Formz para validación de formularios
    ├── screens/                     # Pantallas globales (splash, 404, etc.)
    └── widgets/                     # Widgets globales reutilizables
```

---

## ⚙️ Instalación y configuración

### Pre-requisitos

- Flutter SDK `^3.29.3` y Dart `^3.10.4`
- Android SDK / Dispositivo físico o emulador Android
- Backend WMS API corriendo (ver [workshops_api](https://github.com/tu-usuario/workshops_api))

### 1. Clonar el repositorio

```bash
git clone https://github.com/tu-usuario/wms.git
cd wms
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Configurar variables de entorno

Crea un archivo `.env` en la raíz del proyecto:

```env
API_URL=http://tu-backend-fastapi.com
```

> ⚠️ **Importante:** No subas `.env` al repositorio. Verifica que esté en tu `.gitignore`.

### 4. Ejecutar la app

```bash
# Modo debug
flutter run

# Generar APK de prueba
flutter build apk --debug

# Generar APK release (requiere keystore configurado)
flutter build apk --release --split-per-abi
```

---

## 🔐 Autenticación

La app usa **JWT Bearer Token** con el backend FastAPI. Al hacer login, el token se persiste localmente mediante `KeyValueStorageService` (abstracción sobre `SharedPreferences`) y se adjunta automáticamente a cada petición HTTP a través de interceptores en Dio.

El token incluye en su payload: `username`, `name`, `shop_id` y `exp`.

> Los roles de usuario están pendientes de implementación.

---

## 🗄️ Modelo de datos (Backend)

El backend gestiona las siguientes entidades principales en PostgreSQL:

| Tabla              | Descripción                                               |
| ------------------ | --------------------------------------------------------- |
| `workshops`        | Talleres (entidad raíz multi-tenant)                      |
| `users`            | Usuarios autenticados, vinculados a un taller             |
| `customers`        | Clientes del taller (RUT único por taller)                |
| `vehicles`         | Vehículos asociados a clientes (patente única por taller) |
| `work_orders`      | Órdenes de trabajo con estado, diagnóstico y estimados    |
| `work_order_items` | Ítems de una orden (mano de obra, piezas, costos)         |
| `status_logs`      | Historial de cambios de estado de una orden               |

---

## 📁 Variables de entorno

| Variable  | Descripción                  | Ejemplo                     |
| --------- | ---------------------------- | --------------------------- |
| `API_URL` | URL base del backend FastAPI | `http://192.168.1.100:8000` |

---

## 🔗 Repositorios relacionados

- **Backend API:** [workshops_api](https://github.com/tu-usuario/workshops_api) — FastAPI + PostgreSQL + JWT

---

## 🚀 Roadmap

- [ ] Roles y permisos de usuario (admin, mecánico, recepcionista)
- [ ] Módulo de inventario de repuestos
- [ ] Agenda / citas con calendario
- [ ] Módulo de facturación y pagos
- [ ] Reportes y estadísticas del taller
- [ ] Notificaciones push
- [ ] Soporte offline con caché local
- [ ] Versión iOS

---

## 📄 Licencia

Este proyecto es de uso privado. Todos los derechos reservados.
