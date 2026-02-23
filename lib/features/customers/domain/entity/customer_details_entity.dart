import 'package:wms/domain/entities/entities.dart';

class CustomerDetails {
  final Customer customerData;
  final Workshop workshopData;
  final List<Vehicle> vehicles;

  CustomerDetails({
    required this.customerData,
    required this.workshopData,
    required this.vehicles,
  });
}
