import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Pengaturan', style: AppTypography.headerTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pengaturan', style: AppTypography.displayHeading.copyWith(fontSize: 22, color: AppColors.primary900)),
            const SizedBox(height: 4),
            Text(
              'Konfigurasi parameter sistem, keamanan, dan integrasi blockchain Voteryx.',
              style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Profil Admin Section
            _buildSectionCard(
              icon: Icons.person_outline,
              title: 'Profil Admin',
              children: [
                _buildListTile(
                  title: 'Admin Utama',
                  subtitle: 'admin@voteryx.gov.id',
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network('https://i.pravatar.cc/150?img=11', width: 40, height: 40, fit: BoxFit.cover),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.outlineVariant),
                ),
                const SizedBox(height: 16),
                _buildListTile(
                  title: 'Hak Akses',
                  subtitle: 'Super Administrator (Akses Penuh)',
                  trailing: const Icon(Icons.chevron_right, color: AppColors.outlineVariant),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Keamanan Sistem Section
            _buildSectionCard(
              icon: Icons.shield_outlined,
              title: 'Keamanan Sistem',
              children: [
                _buildSwitchTile(
                  title: 'Autentikasi Dua Faktor (2FA)',
                  subtitle: 'Wajib bagi semua administrator level tinggi.',
                  value: true,
                  onChanged: (val) {},
                ),
                const SizedBox(height: 16),
                _buildListTile(
                  title: 'Ganti Kata Sandi',
                  subtitle: 'Terakhir diperbarui 45 hari yang lalu.',
                  trailing: const Icon(Icons.history, color: AppColors.outlineVariant),
                ),
                const SizedBox(height: 16),
                _buildSwitchTile(
                  title: 'Auto-Lock Sesi',
                  subtitle: 'Keluar otomatis setelah 15 menit tidak aktif.',
                  value: true,
                  onChanged: (val) {},
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Integrasi Blockchain Section
            _buildSectionCard(
              icon: Icons.share_outlined, // Nodes icon proxy
              title: 'Integrasi Blockchain',
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Node Mainnet', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.successTeal, shape: BoxShape.circle)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text('Terhubung (Block Height: 12,948,332)', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.goldDark,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                        elevation: 0,
                      ),
                      child: Text('KELOLA', style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 10)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSwitchTile(
                  title: 'Enkripsi End-to-End',
                  subtitle: 'Menggunakan protokol AES-256 GCM.',
                  value: true,
                  onChanged: (val) {},
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Notifikasi Section
            _buildSectionCard(
              icon: Icons.notifications_none,
              title: 'Notifikasi',
              children: [
                _buildSwitchTile(
                  title: 'Peringatan Real-time',
                  subtitle: 'Notifikasi anomali data pemilih.',
                  value: true,
                  onChanged: (val) {},
                ),
                const SizedBox(height: 16),
                _buildSwitchTile(
                  title: 'Laporan Harian (Email)',
                  subtitle: 'Ringkasan aktivitas sistem jam 00:00.',
                  value: false,
                  onChanged: (val) {},
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
                border: Border.all(color: Colors.red.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Text('Zona Bahaya', style: AppTypography.bodyMedium.copyWith(color: Colors.red, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Reset Seluruh Sistem', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    'Menghapus semua data pemilu dan cache blockchain secara permanen.',
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBA1A1A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: Text('RESET TOTAL', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildSectionCard({required IconData icon, required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
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
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildListTile({required String title, required String subtitle, Widget? leading, Widget? trailing}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leading != null) ...[
          leading,
          const SizedBox(width: 16),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 16),
          trailing,
        ],
      ],
    );
  }

  Widget _buildSwitchTile({required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: const Color(0xFF1E50FF),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: AppColors.outlineVariant.withOpacity(0.5),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.outlineVariant.withOpacity(0.5))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.grid_view, 'Overview', false, () {
                context.pushNamed('admin-dashboard');
              }),
              _buildNavItem(Icons.how_to_vote_outlined, 'Elections', false, () {
                context.pushNamed('admin-proposals');
              }),
              _buildNavItem(Icons.people_outline, 'Voters', false, () {
                context.pushNamed('admin-voters');
              }),
              _buildNavItem(Icons.settings_outlined, 'Settings', true, () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.goldMid,
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.white : AppColors.textSecondary),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.captionBold.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
