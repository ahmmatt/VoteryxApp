// lib/features/user/profile/presentation/screens/profile_settings_screen.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';
import 'package:voteryxapp/core/widgets/gold_button.dart';
import 'package:voteryxapp/features/user/delegation/presentation/providers/delegation_provider.dart';
import '../providers/profile_provider.dart';

class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _nimController;
  late TextEditingController _facultyController;
  late TextEditingController _majorController;
  late TextEditingController _delegateBioController;
  late TextEditingController _delegateVisionController;

  bool _isInitialized = false;
  Uint8List? _pickedAvatarBytes;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _nimController = TextEditingController();
    _facultyController = TextEditingController();
    _majorController = TextEditingController();
    _delegateBioController = TextEditingController();
    _delegateVisionController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _nimController.dispose();
    _facultyController.dispose();
    _majorController.dispose();
    _delegateBioController.dispose();
    _delegateVisionController.dispose();
    super.dispose();
  }

  void _initializeFromProfile(dynamic profile) {
    if (_isInitialized || profile == null) return;
    _fullNameController.text = profile.fullName;
    _phoneController.text = profile.phone ?? '';
    _emailController.text = profile.email ?? '';
    _nimController.text = profile.nim ?? '';
    _facultyController.text = profile.faculty ?? '';
    _majorController.text = profile.major ?? '';
    _delegateBioController.text = profile.delegateBio ?? '';
    _delegateVisionController.text = profile.delegateVision ?? '';
    _isInitialized = true;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(profileUpdateProvider.notifier).updateProfile(
          fullName: _fullNameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          nim: _nimController.text.trim(),
          faculty: _facultyController.text.trim(),
          major: _majorController.text.trim(),
          avatarBytes: _pickedAvatarBytes,
          delegateBio: _delegateBioController.text.trim(),
          delegateVision: _delegateVisionController.text.trim(),
        );

    final updateState = ref.read(profileUpdateProvider);
    if (updateState.error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(updateState.error!),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } else {
      ref.invalidate(userProfileProvider);
      ref.invalidate(publicDelegatesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil disimpan & disinkronkan ke database.'),
            backgroundColor: AppColors.successTeal,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _showAvatarPickerOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
      ),
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Ganti Foto Profil',
                  style: AppTypography.cardTitle.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.lg),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined, color: AppColors.goldMid),
                  title: Text('Ambil Foto dari Kamera', style: AppTypography.bodyText.copyWith(color: AppColors.textPrimary)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _pickAvatarImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined, color: AppColors.goldMid),
                  title: Text('Pilih dari Galeri', style: AppTypography.bodyText.copyWith(color: AppColors.textPrimary)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _pickAvatarImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickAvatarImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _pickedAvatarBytes = bytes;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengambil foto: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final updateState = ref.watch(profileUpdateProvider);

    profileAsync.whenData((profile) {
      _initializeFromProfile(profile);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.primary800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Profil tidak ditemukan'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildAvatarSection(profile.fullName, profile.avatarUrl),
                  const SizedBox(height: AppSpacing.xxl),
                  _buildEditableField(
                    label: 'Nama Lengkap',
                    controller: _fullNameController,
                    icon: Icons.person_outline,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Nama tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildEditableField(
                    label: 'Nomor Telepon',
                    controller: _phoneController,
                    icon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildEditableField(
                    label: 'Alamat Email',
                    controller: _emailController,
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildLockedField(
                    label: 'NIK Terverifikasi',
                    value: '**** **** **** ${profile.nikHash.length >= 4 ? profile.nikHash.substring(profile.nikHash.length - 4) : "8901"} (Terenkripsi)',
                    icon: Icons.badge_outlined,
                    helperText: 'NIK disimpan aman dalam bentuk hash SHA-256 dan tidak ditampilkan penuh.',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildEditableField(
                    label: 'Fakultas',
                    controller: _facultyController,
                    icon: Icons.school_outlined,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildEditableField(
                    label: 'NIM',
                    controller: _nimController,
                    icon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildEditableField(
                    label: 'Jurusan / Spesialisasi',
                    controller: _majorController,
                    icon: Icons.menu_book_outlined,
                  ),
                  if (profile.isDelegate) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _buildEditableField(
                      label: 'Bio Delegasi',
                      controller: _delegateBioController,
                      icon: Icons.info_outline,
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildEditableField(
                      label: 'Visi Delegasi',
                      controller: _delegateVisionController,
                      icon: Icons.visibility_outlined,
                      maxLines: 3,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xxl),
                  _buildSaveButton(updateState),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.goldMid),
        ),
        error: (err, _) => Center(
          child: Text('Gagal memuat profil: $err'),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(String name, String? avatarUrl) {
    final clean = avatarUrl?.trim() ?? '';
    // Tentukan ImageProvider
    ImageProvider? existingImageProvider;
    if (_pickedAvatarBytes != null) {
      existingImageProvider = MemoryImage(_pickedAvatarBytes!);
    } else if (clean.startsWith('data:image')) {
      try {
        final base64Str = clean.split(',').last;
        existingImageProvider = MemoryImage(base64Decode(base64Str));
      } catch (_) {}
    } else if (clean.startsWith('http')) {
      existingImageProvider = NetworkImage(clean);
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () => _showAvatarPickerOptions(context),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary900,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: existingImageProvider != null
                    ? ClipOval(
                        child: Image(
                          image: existingImageProvider,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Text(
                            name.isNotEmpty ? name[0].toUpperCase() : 'U',
                            style: AppTypography.displayHeading.copyWith(color: Colors.white, fontSize: 40),
                          ),
                        ),
                      )
                    : Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'U',
                        style: AppTypography.displayHeading.copyWith(color: Colors.white, fontSize: 40),
                      ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.goldMid,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 3),
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          _pickedAvatarBytes != null ? 'FOTO BARU DIPILIH (TEKAN SIMPAN)' : 'FOTO PROFIL ASLI DATABASE',
          style: AppTypography.captionBold.copyWith(
            color: _pickedAvatarBytes != null ? AppColors.goldMid : AppColors.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.captionBold),
        const SizedBox(height: AppSpacing.xs),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.input),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: AppTypography.bodyText,
            validator: validator,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 22),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLockedField({
    required String label,
    required String value,
    required IconData icon,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.xs),
        CustomPaint(
          painter: _DashedBorderPainter(
            color: AppColors.outlineVariant,
            radius: AppRadius.input,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.input),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(icon, color: AppColors.textSecondary, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value,
                    style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
                  ),
                ),
                const Icon(Icons.lock_outline, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            helperText,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10),
          ),
        ],
      ],
    );
  }

  Widget _buildSaveButton(ProfileUpdateState updateState) {
    return GoldButton(
      label: updateState.isLoading ? 'Menyimpan...' : 'Simpan Perubahan',
      onPressed: updateState.isLoading ? () {} : _saveProfile,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
