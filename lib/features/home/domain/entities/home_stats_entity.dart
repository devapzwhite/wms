class HomeStats {
  final int totalCustomers;
  final int totalVehicles;
  final int totalWorkOrders;
  final int openWorkOrders;
  final int completedWorkOrders;
  final bool isLoading;
  final String? errorMessage;

  HomeStats({
    this.totalCustomers = 0,
    this.totalVehicles = 0,
    this.totalWorkOrders = 0,
    this.openWorkOrders = 0,
    this.completedWorkOrders = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  HomeStats copyWith({
    int? totalCustomers,
    int? totalVehicles,
    int? totalWorkOrders,
    int? openWorkOrders,
    int? completedWorkOrders,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeStats(
      totalCustomers: totalCustomers ?? this.totalCustomers,
      totalVehicles: totalVehicles ?? this.totalVehicles,
      totalWorkOrders: totalWorkOrders ?? this.totalWorkOrders,
      openWorkOrders: openWorkOrders ?? this.openWorkOrders,
      completedWorkOrders: completedWorkOrders ?? this.completedWorkOrders,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
