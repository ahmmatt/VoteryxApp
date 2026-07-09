import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/network/supabase_client.dart';
import 'package:voteryxapp/features/auth/presentation/providers/auth_provider.dart';

class AdminSettingsScreen extends ConsumerStatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  ConsumerState<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends ConsumerState<AdminSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final profile = profileAsync.value;

    final adminName = profile?.fullName ?? 'Admin Voteryx';
    final adminEmail = profile?.email ?? profile?.phone ?? 'admin@voteryx.gov.id';
    final String? photoUrl = null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: AppColors.primary800,
        elevation: 0,
        title: Text(
          'Pengaturan & Profil Admin',
          style: AppTypography.screenTitle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dasbor Pengaturan', style: AppTypography.displayHeading.copyWith(fontSize: 22, color: AppColors.primary900)),
            const SizedBox(height: 4),
            Text(
              'Kelola profil administrator serta keamanan kata sandi sistem Voteryx.',
              style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Profil Admin Section
            _buildSectionCard(
              icon: Icons.person_outline,
              title: 'Profil Admin',
              children: [
                _buildListTile(
                  title: adminName,
                  subtitle: adminEmail,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: (photoUrl != null && photoUrl.isNotEmpty)
                        ? Image.network(
                            photoUrl,
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.admin_panel_settings, size: 44, color: AppColors.goldDark),
                          )
                        : const Icon(Icons.admin_panel_settings, size: 44, color: AppColors.goldDark),
                  ),
                  trailing: const Icon(Icons.edit_outlined, color: AppColors.outlineVariant),
                  onTap: () => _showEditAdminProfileDialog(context, adminName, adminEmail),
                ),
                const SizedBox(height: 16),
                _buildListTile(
                  title: 'Hak Akses & Izin',
                  subtitle: 'Super Administrator (Level 5 - Root)',
                  leading: const Icon(Icons.verified_user_outlined, color: AppColors.successTeal, size: 28),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.outlineVariant),
                  onTap: () => _showAccessRightsDialog(context),
                ),
                const SizedBox(height: 16),
                _buildListTile(
                  title: 'Keluar dari Dasbor',
                  subtitle: 'Akhiri sesi administrator dan kembali ke login',
                  leading: const Icon(Icons.logout, color: AppColors.errorRed, size: 28),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.errorRed),
                  onTap: () => _showLogoutConfirmDialog(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Keamanan Sistem Section (Hanya Ganti Kata Sandi Admin sesuai permintaan)
            _buildSectionCard(
              icon: Icons.shield_outlined,
              title: 'Keamanan Sistem',
              children: [
                _buildListTile(
                  title: 'Ganti Kata Sandi Admin',
                  subtitle: 'Perbarui kata sandi secara berkala untuk keamanan ganda.',
                  leading: const Icon(Icons.lock_reset, color: AppColors.primary900, size: 26),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.outlineVariant),
                  onTap: () => _showChangePasswordSheet(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Zona Bahaya Section
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF6F0),
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.errorRed, size: 22),
                      const SizedBox(width: 8),
                      Text('Zona Bahaya (Danger Zone)', style: AppTypography.bodyBold.copyWith(color: AppColors.errorRed)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Muat Ulang & Reset Cache Sistem', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    'Menghapus cache lokal dan menyegarkan ulang sinkronisasi data pemilu dan delegasi dari cloud.',
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: () => _showResetConfirmDialog(context),
                      icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorRed,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      label: Text('RESET CACHE & MUAT ULANG', style: AppTypography.bodyBold.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  // ─── DIALOG & MODALS ───────────────────────────────────────────────────────

  void _showLogoutConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.logout, color: AppColors.errorRed),
            const SizedBox(width: 8),
            Text('Konfirmasi Keluar', style: AppTypography.bodyBold.copyWith(fontSize: 18)),
          ],
        ),
        content: const Text('Apakah Anda yakin ingin keluar dari dasbor administrator dan kembali ke halaman login?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Batal', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(userProfileProvider.notifier).signOut();
              if (context.mounted) {
                context.goNamed('login');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            child: const Text('Ya, Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditAdminProfileDialog(BuildContext context, String currentName, String currentEmail) {
    final nameCtrl = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit Profil Admin', style: AppTypography.bodyBold.copyWith(fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Email / ID Akses',
                hintText: currentEmail,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final newName = nameCtrl.text.trim();
              if (newName.isNotEmpty) {
                await ref.read(userProfileProvider.notifier).updateProfile(fullName: newName);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profil administrator berhasil diperbarui!')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.goldDark),
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAccessRightsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.verified_user, color: AppColors.successTeal),
            const SizedBox(width: 8),
            Text('Hak Akses Administrator', style: AppTypography.bodyBold.copyWith(fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tingkat Izin: Level 5 (Super Root)', style: AppTypography.captionBold.copyWith(color: AppColors.primary900)),
            const SizedBox(height: 12),
            _buildAccessItem('Manajemen Pemilu & Pembuatan Sesi'),
            _buildAccessItem('Verifikasi & Audit Kandidat Pemilu'),
            _buildAccessItem('Persetujuan & Review Delegasi (Liquid Democracy)'),
            _buildAccessItem('Pemantauan Suara Real-time & Transaksi Blockchain'),
            _buildAccessItem('Konfigurasi Keamanan & Parameter Sistem'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary800),
            child: const Text('Tutup', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.successTeal, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppTypography.caption.copyWith(color: AppColors.primary900))),
        ],
      ),
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    final passCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Ganti Kata Sandi Admin', style: AppTypography.bodyBold.copyWith(fontSize: 18)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Pastikan kata sandi baru mengandung minimal 6 karakter.', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Kata Sandi Baru',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Konfirmasi Kata Sandi Baru',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_reset),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isSubmitting
                        ? null
                        : () async {
                            final newPass = passCtrl.text.trim();
                            if (newPass.isEmpty || newPass.length < 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Kata sandi baru harus minimal 6 karakter!')),
                              );
                              return;
                            }
                            if (newPass != confirmCtrl.text.trim()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Konfirmasi kata sandi tidak cocok!')),
                              );
                              return;
                            }

                            setModalState(() => isSubmitting = true);
                            try {
                              await SupabaseConfig.client.auth.updateUser(
                                UserAttributes(password: newPass),
                              );
                              if (ctx.mounted) Navigator.of(ctx).pop();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('✅ Kata sandi administrator berhasil diperbarui!')),
                                );
                              }
                            } catch (e) {
                              setModalState(() => isSubmitting = false);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Gagal memperbarui kata sandi: $e')),
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text('SIMPAN KATA SANDI BARU', style: AppTypography.bodyBold.copyWith(color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showResetConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning, color: AppColors.errorRed),
            const SizedBox(width: 8),
            Text('Konfirmasi Reset Cache', style: AppTypography.bodyBold.copyWith(fontSize: 18)),
          ],
        ),
        content: const Text('Apakah Anda yakin ingin memuat ulang sinkronisasi dan mereset cache lokal aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.invalidate(userProfileProvider);
              ref.invalidate(loginNotifierProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache lokal berhasil dibersihkan & disinkronisasi ulang!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            child: const Text('Ya, Reset Cache', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── BUILD HELPERS ─────────────────────────────────────────────────────────

  Widget _buildSectionCard({required IconData icon, required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primary900, size: 20),
              ),
              const SizedBox(width: 12),
              Text(title, style: AppTypography.displayHeading.copyWith(fontSize: 18, color: AppColors.primary900)),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildListTile({required String title, required String subtitle, Widget? leading, Widget? trailing, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) ...[
              leading,
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 12),
              trailing,
            ],
          ],
        ),
      ),
    );
  }
}
