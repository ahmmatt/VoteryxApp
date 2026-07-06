import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/features/delegates/delegation/application/delegate_application_provider.dart';

class AdminDelegateApplicationsScreen extends ConsumerWidget {
  const AdminDelegateApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(delegateApplicationProvider);
    final pendingCount = applications.where((app) => app.status == DelegateApplicationStatus.pending).length;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('Pengajuan Delegate ($pendingCount)', style: AppTypography.headerTitle),
        backgroundColor: AppColors.primary800,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: applications.length,
        itemBuilder: (context, index) {
          final app = applications[index];
          final isPending = app.status == DelegateApplicationStatus.pending;
          
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(app.name, style: AppTypography.bodyBold),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('Keahlian: ${app.expertise}', style: AppTypography.caption),
                  Text('Status: ${app.status.name.toUpperCase()}', 
                    style: AppTypography.captionBold.copyWith(
                      color: isPending ? Colors.orange : (app.status == DelegateApplicationStatus.approved ? Colors.green : Colors.red)
                    ),
                  ),
                ],
              ),
              trailing: isPending ? const Icon(Icons.arrow_forward_ios, size: 16) : null,
              onTap: isPending ? () {
                context.pushNamed('admin-delegate-review', pathParameters: {'id': app.id});
              } : null,
            ),
          );
        },
      ),
    );
  }
}
