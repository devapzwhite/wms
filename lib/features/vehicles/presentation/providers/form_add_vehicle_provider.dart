import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:wms/domain/entities/entities.dart';
import 'package:wms/features/vehicles/errors/vehicle_errors.dart';
import 'package:wms/features/vehicles/infrastructure/mappers/vehicle_mapper.dart';
import 'package:wms/features/vehicles/presentation/providers/vehicle_repository_provider.dart';
import 'package:wms/features/vehicles/presentation/providers/vehicles_provider.dart';
import 'package:wms/presentation/inputs/inputs.dart';

final formAddVehicleNotifierProvider =
    NotifierProvider.autoDispose<FormAddVehicleNotifier, FormAddVehicleState>(
      () {
        return FormAddVehicleNotifier();
      },
    );

class FormAddVehicleNotifier extends Notifier<FormAddVehicleState> {
  @override
  FormAddVehicleState build() {
    return FormAddVehicleState();
  }

  void onClientIdSelected(int value) {
    final clientId = value;
    state = state.copyWith(
      clientId: clientId,
      isSubmited: false,
      errorMessage: '',
    );
    print('campo cambiado 1');
  }

  void onTypeChanged(String? value) {
    final tipo = value;
    state = state.copyWith(tipo: tipo);
    print('campo cambiado 2');
  }

  void onPlateChanged(String value) {
    final placa = BasicStringInput.dirty(value: value);
    state = state.copyWith(
      placa: placa,
      isValid: Formz.validate([placa, state.marca, state.modelo]),
    );

    print('campo cambiado 3');
  }

  void onBrandChanged(String value) {
    final marca = BasicStringInput.dirty(value: value);
    state = state.copyWith(
      marca: marca,
      isValid: Formz.validate([state.placa, marca, state.modelo]),
    );
    print('campo cambiado 4');
  }

  void onModelChanged(String value) {
    final modelo = BasicStringInput.dirty(value: value);
    state = state.copyWith(
      modelo: modelo,
      isValid: Formz.validate([state.placa, state.marca, modelo]),
    );
    print('campo cambiado 5');
  }

  void onYearChanged(String value) {
    final anio = value;
    state = state.copyWith(anio: anio);
    print('campo cambiado 6');
  }

  void onSubmit() async {
    final bool isValid = _validate();
    state = state.copyWith(isValid: isValid, isSubmited: true);
    if (!isValid) return;
    final Vehicle vehicle = Vehicle(
      customerId: state.clientId,
      vehicleType: VehicleMapper.textToTipoVehiculo(state.tipo),
      plate: state.placa.value,
      brand: state.marca.value,
      model: state.modelo.value,
      year: int.tryParse(state.anio),
    );
    try {
      await ref.read(vehicleRepositoryProvider).addVehicle(vehicle);
      ref.read(vehiclesNotifierProvider.notifier).loadVehicles();
      //TODO:  HASTA AQUI REGISTRA EL VEHICULO
    } on VehicleErrors catch (e) {
      state = state.copyWith(errorMessage: e.message);
      print('error');
    } catch (e) {
      print(e);
    }
  }

  void clearErrors() {
    state = state.copyWith(errorMessage: "");
  }

  bool _validate() {
    state = state.copyWith(
      placa: BasicStringInput.dirty(value: state.placa.value),
      marca: BasicStringInput.dirty(value: state.marca.value),
      modelo: BasicStringInput.dirty(value: state.modelo.value),
    );
    if (Formz.validate([state.marca, state.marca, state.modelo])) {
      if (state.clientId != 0 && state.tipo != '') {
        return true;
      }
    }
    return false;
  }
}

class FormAddVehicleState {
  final int clientId;
  final String tipo;
  final BasicStringInput placa;
  final BasicStringInput marca;
  final BasicStringInput modelo;
  final String anio;
  final bool isValid;
  final String errorMessage;
  final bool isSubmited;
  FormAddVehicleState({
    this.clientId = 0,
    this.tipo = '',
    this.placa = const BasicStringInput.pure(),
    this.marca = const BasicStringInput.pure(),
    this.modelo = const BasicStringInput.pure(),
    this.anio = '',
    this.isValid = false,
    this.errorMessage = "",
    this.isSubmited = false,
  });
  FormAddVehicleState copyWith({
    final int? clientId,
    final String? tipo,
    final BasicStringInput? placa,
    final BasicStringInput? marca,
    final BasicStringInput? modelo,
    final String? anio,
    final bool? isValid,
    final String? errorMessage,
    final bool? isSubmited,
  }) => FormAddVehicleState(
    clientId: clientId ?? this.clientId,
    tipo: tipo ?? this.tipo,
    placa: placa ?? this.placa,
    marca: marca ?? this.marca,
    modelo: modelo ?? this.modelo,
    anio: anio ?? this.anio,
    isValid: isValid ?? this.isValid,
    errorMessage: errorMessage ?? this.errorMessage,
    isSubmited: isSubmited ?? this.isSubmited,
  );
}
