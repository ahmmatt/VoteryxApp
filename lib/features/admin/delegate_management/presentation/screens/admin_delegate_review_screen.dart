import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/features/delegates/delegation/application/delegate_application_provider.dart';

class AdminDelegateReviewScreen extends ConsumerWidget {
  final String id;
  const AdminDelegateReviewScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(delegateApplicationProvider);
    final app = applications.firstWhere((element) => element.id == id, orElse: () => throw Exception('Not found'));

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('Review Pengajuan', style: AppTypography.headerTitle),
        backgroundColor: AppColors.primary800,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detail Pengaju', style: AppTypography.displayHeading.copyWith(fontSize: 20)),
            const SizedBox(height: 16),
            _buildDetailRow('Nama', app.name),
            _buildDetailRow('NIM', app.isStudent ? app.nim : 'Bukan Mahasiswa'),
            _buildDetailRow('Keahlian', app.expertise),
            _buildDetailRow('Bio', app.bio),
            _buildDetailRow('Riwayat Pencapaian / Track Record', app.trackRecord),
            _buildDetailRow('Portofolio', app.portfolioUrl),
            
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(delegateApplicationProvider.notifier).reject(app.id);
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: const Text('Tolak', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(delegateApplicationProvider.notifier).approve(app.id);
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: const Text('Setujui', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.bodyText),
        ],
      ),
    );
  }
}
