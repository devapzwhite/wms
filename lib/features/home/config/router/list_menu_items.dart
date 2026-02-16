import 'package:flutter/material.dart';
import 'package:wms/domain/entities/menu_item_entity.dart';

final List<MenuItem> listMenuItems = [
  MenuItem(icon: Icons.group_sharp, title: 'Clientes', route: '/customers'),
  MenuItem(
    icon: Icons.directions_car_filled_sharp,
    title: 'Vehiculos',
    route: '/vehicles',
  ),
  MenuItem(icon: Icons.note_add, title: 'Ordenes', route: '/workorders'),
];

final List<MenuItem> customerListMenuItems = [
  MenuItem(
    icon: Icons.add,
    title: 'Agregar Cliente',
    route: '/customers/addcustomer',
  ),
  MenuItem(
    icon: Icons.edit,
    title: 'Editar Cliente',
    route: '/customers/updatecustomer',
  ),
];

final List<MenuItem> vehicleListMenuItems = [
  MenuItem(
    icon: Icons.minor_crash_rounded,
    title: 'Agregar Vehiculo',
    route: '/vehicles/addvehicle',
  ),
  MenuItem(
    icon: Icons.edit,
    title: 'Editar Vehiculo',
    route: '/vehicles/updatevehicle',
  ),
];

final List<MenuItem> workOrderListMenuItems = [
  MenuItem(
    icon: Icons.note_add_rounded,
    title: 'Agregar Orden',
    route: '/workorders/addworkorder',
  ),
  MenuItem(
    icon: Icons.note_alt_rounded,
    title: 'Editar Orden',
    route: '/workorders/editworkorder',
  ),
];
