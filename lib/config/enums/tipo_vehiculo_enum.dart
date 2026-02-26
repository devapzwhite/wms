enum TipoVehiculo {
  car('CAR', 'Auto'),
  suv('SUV', 'Vagoneta'),
  van('VAN', 'Furgón'),
  pickup('PICKUP', 'Camioneta'),
  minivan('MINIVAN', 'Minivan'),
  truck('TRUCK', 'Camión'),
  bus('BUS', 'Bus / Minibús'),
  skidSteer('SKID_STEER', 'Minicargador'),
  motorcycle('MOTORCYCLE', 'Motocicleta');

  final String label; // Para el backend
  final String nombre; // Para mostrar en UI

  const TipoVehiculo(this.label, this.nombre);
}
