// lib/features/profile/presentation/screens/delegate_update_skills_screen.dart
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

// ─────────────────── Model ─────────────────────────────────────────────────

/// Model untuk satu skill delegate.
class _SkillItem {
  final String name;
  final bool isVerified; // diverifikasi dewan = tanda centang hijau
  final IconData icon;

  const _SkillItem({
    required this.name,
    this.isVerified = false,
    this.icon = Icons.military_tech_outlined,
  });
}

// ─────────────────── Screen ────────────────────────────────────────────────

/// Layar Update Keahlian — memungkinkan delegate mencari, menambah,
/// dan menghapus keahlian dari profil publik mereka.
class DelegateUpdateSkillsScreen extends StatefulWidget {
  const DelegateUpdateSkillsScreen({super.key});

  @override
  State<DelegateUpdateSkillsScreen> createState() =>
      _DelegateUpdateSkillsScreenState();
}

class _DelegateUpdateSkillsScreenState
    extends State<DelegateUpdateSkillsScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Skills aktif milik user
  final List<_SkillItem> _currentSkills = [
    const _SkillItem(
      name: 'Kebijakan Kampus',
      isVerified: true,
      icon: Icons.account_balance_outlined,
    ),
    const _SkillItem(
      name: 'Advokasi',
      isVerified: true,
      icon: Icons.gavel_rounded,
    ),
    const _SkillItem(
      name: 'Penulisan Laporan',
      isVerified: false,
      icon: Icons.edit_document,
    ),
    const _SkillItem(
      name: 'Kepemimpinan',
      isVerified: false,
      icon: Icons.stars_outlined,
    ),
  ];

  // Saran skill yang belum dimiliki
  static const List<String> _suggestions = [
    'Manajemen Krisis',
    'Diplomasi',
    'Analisis Data',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _removeSkill(int index) {
    setState(() => _currentSkills.removeAt(index));
  }

  void _addSuggestedSkill(String name) {
    if (_currentSkills.any((s) => s.name == name)) return;
    setState(() {
      _currentSkills.add(_SkillItem(name: name));
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = _currentSkills.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Banner (diperlakukan sebagai card navy flush ke appbar)
                  _buildHeroBanner(),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.xl,
                      AppSpacing.md,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── CARI KEAHLIAN BARU ──────────────────────────
                        Text(
                          'CARI KEAHLIAN BARU',
                          style: AppTypography.captionBold.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildSearchField(),
                        const SizedBox(height: 14),
                        _buildSuggestions(),
                        const SizedBox(height: AppSpacing.xl),

                        // ── KEAHLIAN SAAT INI ────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'KEAHLIAN SAAT INI',
                              style: AppTypography.captionBold.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                                letterSpacing: 1.2,
                              ),
                            ),
                            _ActiveBadge(count: activeCount),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Skills list
                        ...List.generate(_currentSkills.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _buildSkillRow(_currentSkills[i], i),
                          );
                        }),

                        const SizedBox(height: AppSpacing.xl),

                        // Footer note
                        Center(
                          child: Text(
                            'Tanda centang hijau menunjukkan keahlian\nyang telah diverifikasi oleh dewan.',
                            textAlign: TextAlign.center,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.outline,
                              fontSize: 11,
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Pinned Save Button ─────────────────────────────────────────
          _buildSaveButton(context),
        ],
      ),
    );
  }

  // ─────────────────────────── AppBar ──────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary800,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Update Keahlian',
        style: AppTypography.headerTitle.copyWith(color: Colors.white),
      ),
    );
  }

  // ─────────────────── Hero Banner ─────────────────────────────────
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary800,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Text content
          Padding(
            padding: const EdgeInsets.only(right: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perkuat Portofolio Anda',
                  style: AppTypography.displayHeading.copyWith(
                    fontSize: 22,
                    color: Colors.white,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pilih keahlian yang paling relevan dengan\nperan delegasi Anda saat ini.',
                  style: AppTypography.bodyText.copyWith(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          // Decorative icon — kanan bawah
          Positioned(
            right: 0,
            bottom: -4,
            child: Icon(
              Icons.stars_rounded,
              size: 80,
              color: Colors.white.withValues(alpha: 0.09),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────── Search Field ────────────────────────────────
  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.input),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: TextField(
        controller: _searchController,
        style: AppTypography.bodyText.copyWith(
          color: AppColors.primary900,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'Ketik keahlian (misal: Negosiasi, Riset...)',
          hintStyle: AppTypography.bodyText.copyWith(
            color: AppColors.outline,
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // ─────────────────── Suggestion Chips ────────────────────────────
  Widget _buildSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saran untuk Anda:',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _suggestions.map((s) {
            return _SuggestionChip(
              label: s,
              onTap: () => _addSuggestedSkill(s),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─────────────────── Skill Row ────────────────────────────────────
  Widget _buildSkillRow(_SkillItem skill, int index) {
    const Color teal = Color(0xFF10B981);
    const Color tealBg = Color(0xFFD1FAE5);

    final bool isVerified = skill.isVerified;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: isVerified ? tealBg : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isVerified
              ? teal.withValues(alpha: 0.35)
              : AppColors.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Icon(
            skill.icon,
            color: isVerified ? teal : AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              skill.name,
              style: AppTypography.bodyMedium.copyWith(
                color: isVerified ? teal : AppColors.primary900,
                fontWeight: isVerified ? FontWeight.w700 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _removeSkill(index),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.close_rounded,
                color: isVerified ? teal : AppColors.textSecondary,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────── Save Button ─────────────────────────────────
  Widget _buildSaveButton(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.check_rounded, size: 18),
            label: Text(
              'Simpan Keahlian',
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.goldDark,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────── Sub-widgets ──────────────────────────────────────────

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary900,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count Aktif',
        style: AppTypography.captionBold.copyWith(
          color: Colors.white,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.textSecondary,
              size: 14,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primary900,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
