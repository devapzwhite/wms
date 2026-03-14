Workshops API – Documentación de Endpoints
Base URL
Producción: https://TU_DOMINIO/api/v1

Desarrollo: http://localhost:8000/api/v1

Autenticación
Tipo de auth
Esquema: Bearer JWT

Header:
Authorization: Bearer <token>

Endpoints Auth
POST /auth/login
Descripción: Inicia sesión y devuelve un token JWT.

Body (ejemplo):

json
{
"email": "user@example.com",
"password": "string"
}
Respuesta 200 (ejemplo):

json
{
"access_token": "jwt_token_here",
"token_type": "bearer"
}
Errores comunes:

400/401: Credenciales inválidas.

(Agrega aquí más endpoints de auth si los tienes: register, refresh, etc.)

Customers
POST /customers
Descripción: Crea un nuevo cliente asociado al workshop del usuario autenticado.

Auth: Requiere token válido.

Body (schema CustomerCreate, ejemplo):

json
{
"fullName": "John Doe",
"documentId": "12345678",
"phone": "+56 9 1234 5678",
"email": "john@example.com"
}
Respuesta 201:

json
{
"id": 1,
"fullName": "John Doe",
"documentId": "12345678",
"phone": "+56 9 1234 5678",
"email": "john@example.com",
"isActive": true
}
GET /customers
Descripción: Lista todos los clientes del workshop del usuario.

Auth: Requiere token válido.

Respuesta 200 (ejemplo):

json
[
{
"id": 1,
"fullName": "John Doe",
"documentId": "12345678",
"phone": "+56 9 1234 5678",
"email": "john@example.com",
"isActive": true
}
]
GET /customers/by_document/{document_id}
Descripción: Obtiene un cliente por documento dentro del workshop actual.

Path params:

document_id (string)

Respuesta 200: CustomerRead.

Errores: 404 si no existe.

GET /customers/by_id/{customer_id}
Descripción: Obtiene un cliente por id dentro del workshop actual.

Path params:

customer_id (int)

Respuesta 200: CustomerRead.

Errores: 404 si no existe.

GET /customers/{customer_id}/details
Descripción: Devuelve detalle de cliente + workshop + vehículos asociados.

Path params:

customer_id (int)

Respuesta 200: CustomerReadDetail.

Errores: 404 "Customer not found".

PUT /customers/{customer_id}
Descripción: Actualiza un cliente existente.

Path params:

customer_id (int)

Body: CustomerUpdate.

Respuesta 200: CustomerRead.

Errores: 404/403 según pertenezca o no al workshop.

Vehicles
GET /vehicles
Descripción: Lista todos los vehículos del workshop del usuario.

Auth: Requiere token válido.

Respuesta 200: List[VehicleRead].

GET /vehicles/searchByPlate/{plate}
Descripción: Busca vehículo por placa dentro del workshop.

Path params:

plate (string)

Respuesta 200: VehicleRead.

Errores: 404 si no existe.

GET /vehicles/searchById/{id}
Descripción: Busca vehículo por id dentro del workshop.

Path params:

id (int)

Respuesta 200: VehicleRead.

Errores: 404 si no existe.

POST /vehicles
The Descripción: Crea un nuevo vehículo asociado al workshop del usuario.

Body (CreateVehicle – ejemplo):

json
{
"plate": "AA-BB-11",
"brand": "Toyota",
"model": "Yaris",
"year": 2015,
"customer_id": 1
}
Respuesta 200: VehicleRead.

GET /vehicles/{id}/workorders
Descripción: Devuelve detalle del vehículo + cliente + órdenes de trabajo asociadas.

Path params:

id (int)

Respuesta 200: VehicleDetailRead.

PUT /vehicles/{id}
Descripción: Actualiza un vehículo existente del workshop.

Path params:

id (int)

Body: VehicleUpdate.

Respuesta 200: VehicleRead.

Work Orders
Nota: Los endpoints usan /workorders/ con slash final.

GET /workorders/
Descripción:

Sin query: lista todas las órdenes de trabajo del workshop.

Con query id: devuelve una sola orden por id.

Query params (opcionales):

id (int): Id de la work order a obtener.

Respuesta 200:

Sin id: List[WorkOrdersRead].

Con id: WorkOrdersReadId.

POST /workorders/
Descripción: Crea una nueva orden de trabajo asociada al workshop del usuario.

Body (NewWorkOrder – ejemplo):

json
{
"vehicle_id": 1,
"customer_id": 1,
"description": "Cambio de aceite",
"status": "OPEN"
}
Respuesta 200: WorkOrdersReadId con el id de la orden.

PUT /workorders/{id}
Descripción: Actualiza una orden de trabajo existente.

Path params:

id (int)

Body: WorkOrderUpdate.

Respuesta 200: WorkOrdersRead.

Tabla Resumen de Endpoints
| Recurso | Método | Path | Descripción |
| ---------- | ------ | ------------------------------ | --------------------------------------- |
| Auth | POST | /auth/login | Login, devuelve JWT |
| Customers | POST | /customers | Crear cliente |
| Customers | GET | /customers | Listar clientes |
| Customers | GET | /customers/by_document/{id} | Cliente por documento |
| Customers | GET | /customers/by_id/{customer_id} | Cliente por id |
| Customers | GET | /customers/{id}/details | Detalle cliente + relaciones |
| Customers | PUT | /customers/{id} | Actualizar cliente |
| Vehicles | GET | /vehicles | Listar vehículos |
| Vehicles | GET | /vehicles/searchByPlate/{p} | Vehículo por placa |
| Vehicles | GET | /vehicles/searchById/{id} | Vehículo por id |
| Vehicles | POST | /vehicles | Crear vehículo |
| Vehicles | GET | /vehicles/{id}/workorders | Vehículo + workorders |
| Vehicles | PUT | /vehicles/{id} | Actualizar vehículo |
| WorkOrders | GET | /workorders/ | Listar ó obtener workorder por query id |
| WorkOrders | POST | /workorders/ | Crear workorder |
| WorkOrders | PUT | /workorders/{id} | Actualizar workorder |
