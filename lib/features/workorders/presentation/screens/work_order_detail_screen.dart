import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wms/config/enums/status_enum.dart';
import 'package:wms/features/auth/presentation/providers/auth_provider.dart';
import 'package:wms/features/workorders/presentation/providers/work_order_detail_providers.dart';
import 'package:wms/presentation/widgets/widgets.dart';

/// Helper para obtener la URL completa de una foto
String _getPhotoUrl(String? photoPath) {
  if (photoPath == null || photoPath.isEmpty) return '';
  // Si ya es URL completa, retornarla
  if (photoPath.startsWith('http')) return photoPath;
  // Construir URL completa desde la base del API
  // Las fotos están protegidas en /media/ según la documentación
  final baseUrl = dotenv.get('API_URL');
  return '$baseUrl/media/$photoPath';
}

class WorkOrderDetailScreen extends ConsumerWidget {
  final int idWorkOrder;

  const WorkOrderDetailScreen({super.key, required this.idWorkOrder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String title = 'Detalle de Orden de Trabajo';
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(workOrderNotifierProvider(idWorkOrder));

    // Obtener token para imágenes protegidas
    final authState = ref.watch(authProvider);
    final token = authState.userSession?.token.accessToken ?? '';

    if (state.isLoading) {
      return Scaffold(
        appBar: AppBarCustom(title: title),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBarCustom(title: title),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: colors.error),
              const SizedBox(height: 16),
              Text('Error: ${state.errorMessage}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(workOrderNotifierProvider(idWorkOrder).notifier)
                      .refresh();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    final workOrder = state.workOrder;
    if (workOrder == null) {
      return Scaffold(
        appBar: AppBarCustom(title: title),
        body: const Center(child: Text('Orden de trabajo no encontrada')),
      );
    }

    return Scaffold(
      appBar: AppBarCustom(title: title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estado de la orden
            _buildStatusSection(context, workOrder.status),
            const SizedBox(height: 24),

            // Diagnóstico inicial
            _buildSectionTitle(context, 'Diagnóstico Inicial'),
            const SizedBox(height: 8),
            _buildContentCard(
              context,
              workOrder.initialDiagnosis ?? 'Sin diagnóstico inicial',
            ),
            const SizedBox(height: 24),

            // Notas
            _buildSectionTitle(context, 'Notas'),
            const SizedBox(height: 8),
            _buildContentCard(
              context,
              workOrder.notes?.isNotEmpty == true
                  ? workOrder.notes!
                  : 'Sin notas',
            ),
            const SizedBox(height: 24),

            // Fechas
            _buildSectionTitle(context, 'Fechas'),
            const SizedBox(height: 8),
            _buildDatesCard(context, workOrder),
            const SizedBox(height: 24),

            // Estimaciones
            if (workOrder.laborEstimate != null ||
                workOrder.partsEstimate != null) ...[
              _buildSectionTitle(context, 'Estimaciones'),
              const SizedBox(height: 8),
              _buildEstimationsCard(context, workOrder),
              const SizedBox(height: 24),
            ],

            // Ítems de la orden
            _buildSectionTitle(
              context,
              'Ítems (${state.workOrderItem.length})',
            ),
            const SizedBox(height: 8),
            if (state.workOrderItem.isEmpty)
              _buildContentCard(context, 'No hay ítems registrados')
            else
              ...state.workOrderItem.map(
                (item) => _buildItemCard(context, item, token),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildStatusSection(BuildContext context, WorkStatus status) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(_getStatusIcon(status), size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Estado'),
                Text(
                  status.nombre,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(WorkStatus status) {
    switch (status) {
      case WorkStatus.received:
        return Icons.inbox;
      case WorkStatus.inProgress:
        return Icons.build;
      case WorkStatus.completed:
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildContentCard(BuildContext context, String content) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(16), child: Text(content)),
    );
  }

  Widget _buildDatesCard(BuildContext context, dynamic workOrder) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (workOrder.checkIn != null)
              _buildDateRow(context, 'Check-in', workOrder.checkIn!),
            if (workOrder.checkOut != null)
              _buildDateRow(context, 'Check-out', workOrder.checkOut!),
            if (workOrder.createdAt != null)
              _buildDateRow(context, 'Creado', workOrder.createdAt!),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRow(BuildContext context, String label, DateTime date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
          ),
        ],
      ),
    );
  }

  Widget _buildEstimationsCard(BuildContext context, dynamic workOrder) {
    final labor = workOrder.laborEstimate ?? 0;
    final parts = workOrder.partsEstimate ?? 0;
    final total = labor + parts;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildEstimationRow(context, 'Mano de obra', labor),
            const Divider(),
            // _buildEstimationRow(context, 'Repuestos', double.parse(parts)),
            // const Divider(),
            _buildEstimationRow(context, 'Total', total, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildEstimationRow(
    BuildContext context,
    String label,
    double amount, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? const TextStyle(fontWeight: FontWeight.bold)
                : null,
          ),
          Text(
            '${amount.toStringAsFixed(0)} CLP',
            style: isTotal
                ? const TextStyle(fontWeight: FontWeight.bold)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, dynamic item, String token) {
    // Verificar si hay fotos
    final hasBeforePhoto =
        item.beforePhoto != null && item.beforePhoto!.isNotEmpty;
    final hasAfterPhoto =
        item.afterPhoto != null && item.afterPhoto!.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado: tipo y cantidad
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    _getItemTypeLabel(item.itemType),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                if (item.quantity != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'x${item.quantity}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Descripción
            Text(
              item.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            // Precios
            if (item.unitPrice != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Precio unit.: ${item.unitPrice!.toStringAsFixed(0)} CLP',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  if (item.quantity != null)
                    Text(
                      'Subtotal: ${(item.unitPrice! * item.quantity!).toStringAsFixed(0)} CLP',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ],

            // Fotos Before/After
            if (hasBeforePhoto || hasAfterPhoto) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Fotos del trabajo',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // Foto Antes
                  if (hasBeforePhoto)
                    Expanded(
                      child: _buildPhotoCard(
                        context: context,
                        label: 'Antes',
                        photoUrl: item.beforePhoto,
                        token: token,
                      ),
                    ),
                  if (hasBeforePhoto && hasAfterPhoto)
                    const SizedBox(width: 12),
                  // Foto Después
                  if (hasAfterPhoto)
                    Expanded(
                      child: _buildPhotoCard(
                        context: context,
                        label: 'Después',
                        photoUrl: item.afterPhoto,
                        token: token,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Widget para mostrar una foto en miniatura con vista previa al tap
  Widget _buildPhotoCard({
    required BuildContext context,
    required String label,
    required String photoUrl,
    required String token,
  }) {
    // Construir URL completa
    final fullUrl = _getPhotoUrl(photoUrl);

    if (fullUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => _showFullScreenImage(context, fullUrl, label, token),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                // Imagen en miniatura
                Image.network(
                  fullUrl,
                  headers: {'Authorization': 'Bearer $token'},
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 120,
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 32,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                // Icono de expandir
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.zoom_in,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Muestra la imagen en pantalla completa
  void _showFullScreenImage(
    BuildContext context,
    String photoUrl,
    String label,
    String token,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            // Imagen
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  photoUrl,
                  headers: {'Authorization': 'Bearer $token'},
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // Etiqueta
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Botón cerrar
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white),
                style: IconButton.styleFrom(backgroundColor: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getItemTypeLabel(String itemType) {
    switch (itemType.toUpperCase()) {
      case 'DIAGNOSIS':
        return 'Diagnóstico';
      case 'LABOR':
        return 'Mano de obra';
      case 'PART':
        return 'Repuesto';
      case 'OTHER':
        return 'Otro';
      default:
        return itemType;
    }
  }
}
