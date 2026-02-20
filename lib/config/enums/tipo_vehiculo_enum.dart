enum TipoVehiculo {
  car('CAR', 'Auto'),
  suv('SUV', 'SUV'),
  van('VAN', 'Van'),
  pickup('PICKUP', 'Pickup'),
  truck('TRUCK', 'Camión'),
  skidSteer('SKID_STEER', 'Minicargador'),
  motorcycle('MOTORCYCLE', 'Motocicleta');

  final String label; // Para el backend
  final String nombre; // Para mostrar en UI

  const TipoVehiculo(this.label, this.nombre);
}
