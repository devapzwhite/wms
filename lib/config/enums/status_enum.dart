enum WorkStatus {
  received('RECEIVED', 'RECIBIDO'),
  diagnosis('DIAGNOSIS', 'DIAGNÓSTICO'),
  waitingAproval('WAITING_APPROVAL', 'ESPERANDO APROBACIÓN'),
  aproved('APPROVED', 'APROBADO'),
  inProgress('IN_PROGRESS', 'EN CURSO'),
  waitingParts('WAITING_PARTS', 'ESPERANDO PIEZAS'),
  reapired('REPAIRED', 'REPARADO'),
  readyForDelivery('READY_FOR_DELIVERY', 'LISTO PARA ENTREGA'),
  completed('COMPLETED', 'COMPLETO'),
  canceled('CANCELLED', 'CANCELADO');

  final String label;
  final String nombre;

  const WorkStatus(this.label, this.nombre);
}
