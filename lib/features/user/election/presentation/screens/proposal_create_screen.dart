import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../features/user/election_proposal/presentation/screens/my_election_proposals_screen.dart';

class ProposalCreateScreen extends StatefulWidget {
  const ProposalCreateScreen({super.key});

  @override
  State<ProposalCreateScreen> createState() => _ProposalCreateScreenState();
}

class _ProposalCreateScreenState extends State<ProposalCreateScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Ajukan Pemilihan Baru', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepCircle(0, isCompleted: _currentStep > 0),
          _buildStepLine(isActive: _currentStep >= 1),
          _buildStepCircle(1, isCompleted: _currentStep > 1),
          _buildStepLine(isActive: _currentStep >= 2),
          _buildStepCircle(2, isCompleted: false),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int stepIndex, {bool isCompleted = false}) {
    final isActive = _currentStep == stepIndex;
    final isPast = _currentStep > stepIndex;
    
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: (isActive || isPast) ? AppColors.goldDark : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: (isActive || isPast) ? AppColors.goldDark : AppColors.outlineVariant,
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: isCompleted
          ? const Icon(Icons.check, color: Colors.white, size: 18)
          : Text(
              '${stepIndex + 1}',
              style: AppTypography.captionBold.copyWith(
                color: (isActive || isPast) ? Colors.white : AppColors.textSecondary,
              ),
            ),
    );
  }

  Widget _buildStepLine({required bool isActive}) {
    return Container(
      width: 40,
      height: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: isActive ? AppColors.goldDark : AppColors.outlineVariant,
    );
  }

  // ── Step 1: Info Dasar ──────────────────────────────────────────────────────
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('P1 — Info Dasar', style: AppTypography.displayHeading.copyWith(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            'Ajukan pemilihan untuk organisasi atau jabatan kamu. Admin akan melakukan review sebelum pemilihan dijalankan.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xxl),
          
          // Form Container
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputField(
                  label: 'Nama Pemilihan',
                  hint: 'Contoh: Pemilihan Ketua HIMA TI 2026',
                  suffixIcon: Icons.edit_outlined,
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildInputField(
                  label: 'Jenis Pemilihan',
                  hint: 'Ketua Organisasi Mahasiswa',
                  suffixIcon: Icons.keyboard_arrow_down,
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildInputField(
                  label: 'LEMBAGA / ORGANISASI PENGUSUL',
                  hint: 'HIMA Teknik Informatika',
                  suffixIcon: Icons.edit_outlined,
                  helperText: 'Berdasarkan jabatan kamu sebagai Ketua HIMA',
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildTextAreaField(
                  label: 'Tujuan Pengajuan',
                  hint: 'Jelaskan tujuan pemilihan ini...',
                  counterText: '0/300',
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Periode Diusulkan', style: AppTypography.captionBold),
                const SizedBox(height: AppSpacing.xs),
                _buildDateField(hint: 'mm/dd/yyyy', suffixText: 'MULAI'),
                const SizedBox(height: AppSpacing.sm),
                _buildDateField(hint: 'mm/dd/yyyy', suffixText: 'SELESAI'),
                const SizedBox(height: AppSpacing.lg),
                Text('Estimasi Jumlah Pemilih', style: AppTypography.captionBold),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.outlineVariant),
                    borderRadius: BorderRadius.circular(AppRadius.input),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Contoh: 1200',
                            hintStyle: AppTypography.bodyText.copyWith(color: AppColors.outline),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text('orang', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Estimasi ini membantu server mengalokasikan beban pemilihan.',
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.xxl),
          _buildPrimaryButton(
            text: 'Lanjut: Tambah Kandidat',
            icon: Icons.arrow_forward,
            onTap: _nextStep,
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  // ── Step 2: Daftar Kandidat ──────────────────────────────────────────────────
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Daftar Kandidat', style: AppTypography.displayHeading.copyWith(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            'Masukkan nama dan NIM calon kandidat. Mereka akan menerima notifikasi untuk melengkapi profil setelah usulan disetujui.',
            style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Info Box
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E6F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info, color: AppColors.primary800, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Sistem pemilihan memerlukan minimal 2 kandidat terverifikasi untuk melanjutkan ke tahap peninjauan.',
                    style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500, color: AppColors.primary800),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          
          // Candidate Cards
          _buildCandidateFormCard(
            title: 'KANDIDAT 1',
            nameVal: 'Arjuna Pratama',
            nimVal: '2021001234',
            status: 'NIM terverifikasi',
            isVerified: true,
            isError: false,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildCandidateFormCard(
            title: 'KANDIDAT 2',
            nameVal: 'Joko Susilo',
            nimVal: '2019998877',
            status: 'NIM tidak ditemukan',
            isVerified: false,
            isError: true,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildCandidateFormCard(
            title: 'KANDIDAT 3',
            nameVal: '',
            nimVal: '',
            isDashed: true,
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Tambah Kandidat Lain Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFE6EFFF),
              borderRadius: BorderRadius.circular(8),
              // We should use dashed border, but using a solid border for simplicity
              border: Border.all(color: const Color(0xFFB5C9F0)), 
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_circle_outline, color: AppColors.primary800, size: 20),
                const SizedBox(width: 8),
                Text('Tambah Kandidat Lain', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary800)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          
          // Bottom Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: _prevStep,
                icon: const Icon(Icons.arrow_back, color: AppColors.primary800, size: 18),
                label: Text('Kembali', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary800)),
              ),
              InkWell(
                onTap: _nextStep,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.goldDark,
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD4A030), Color(0xFFB38622)],
                    ),
                  ),
                  child: Row(
                    children: [
                      Text('Lanjut: Review', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  // ── Step 3: Review ──────────────────────────────────────────────────────────
  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ringkasan Proposal Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EFEA), // Light beige
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  child: Icon(Icons.verified_user_outlined, size: 60, color: AppColors.goldMid.withOpacity(0.1)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ringkasan Proposal', style: AppTypography.screenTitle.copyWith(fontSize: 18)),
                    const SizedBox(height: AppSpacing.lg),
                    _buildSummaryItem('Nama Pemilihan', 'Pemilihan Ketua Dewan Perwakilan Rakyat 2024'),
                    const SizedBox(height: AppSpacing.sm),
                    _buildSummaryItem('Jenis', 'Pemilihan Umum Tertutup'),
                    const SizedBox(height: AppSpacing.sm),
                    _buildSummaryItemWithBadge('Pengusul', 'Sekretariat Negara', 'VERIFIED'),
                    const SizedBox(height: AppSpacing.sm),
                    _buildSummaryItem('Periode', '12 Okt - 15 Okt 2024'),
                    const SizedBox(height: AppSpacing.sm),
                    _buildSummaryItem('Estimasi Pemilih', '2,450 Anggota Terdaftar'),
                    const SizedBox(height: AppSpacing.sm),
                    _buildSummaryItem('Tujuan', 'Rotasi Kepemimpinan Legislatif'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Daftar Kandidat Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Daftar\nKandidat', style: AppTypography.screenTitle.copyWith(fontSize: 18)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text('3 Kandidat\nTerdaftar', textAlign: TextAlign.right, style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.textSecondary)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildCandidateSummaryItem('AP', 'Arjuna Pratama', 'NIP: 198804012012011002 • Fraksi G-A'),
                const SizedBox(height: AppSpacing.md),
                _buildCandidateSummaryItem('SB', 'Siti Bahari', 'NIP: 199102142015032001 • Fraksi G-B'),
                const SizedBox(height: AppSpacing.md),
                _buildCandidateSummaryItem('DR', 'Dodi Rustandi', 'NIP: 198505222010011005 • Fraksi G-C'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Informasi Proses Box
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE0B2), // Light orange
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.access_time_filled, color: Color(0xFF8D6E63), size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Informasi Proses', style: AppTypography.captionBold.copyWith(color: const Color(0xFF4E342E))),
                      const SizedBox(height: 2),
                      Text(
                        'Proposal Anda akan melalui tahap verifikasi teknis oleh tim pusat dalam waktu estimasi 1-2 hari kerja.',
                        style: AppTypography.caption.copyWith(color: const Color(0xFF4E342E)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Bottom Container
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: false,
                        onChanged: (val) {},
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Saya menyatakan bahwa data yang diberikan benar dan telah disetujui oleh pimpinan lembaga berwenang sesuai regulasi yang berlaku.',
                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildPrimaryButton(
                  text: 'Kirim Usulan',
                  icon: Icons.send,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MyElectionProposalsScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton.icon(
                  onPressed: _prevStep,
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary800, size: 14),
                  label: Text('Edit', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary800)),
                ),
                const Divider(height: 32),
                Row(
                  children: [
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF34C759), shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text('Sistem Siap Mengirim', style: AppTypography.captionBold.copyWith(fontSize: 10, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE6EFFF),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'ID Proposal Sementara: #PR-2024-0012',
                style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.primary800),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────
  
  Widget _buildInputField({required String label, required String hint, IconData? suffixIcon, String? helperText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.captionBold),
        const SizedBox(height: AppSpacing.xs),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.outlineVariant),
            borderRadius: BorderRadius.circular(AppRadius.input),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.bodyText.copyWith(color: AppColors.outline),
              suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: AppColors.outline) : null,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 6),
          Text(helperText, style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
        ],
      ],
    );
  }

  Widget _buildTextAreaField({required String label, required String hint, required String counterText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.captionBold),
            Text(counterText, style: AppTypography.caption.copyWith(color: AppColors.outline)),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.outlineVariant),
            borderRadius: BorderRadius.circular(AppRadius.input),
          ),
          child: TextFormField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.bodyText.copyWith(color: AppColors.outline),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({required String hint, required String suffixText}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.outline),
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTypography.bodyText.copyWith(color: AppColors.outline),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(suffixText, style: AppTypography.captionBold.copyWith(color: AppColors.outline)),
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateFormCard({
    required String title,
    required String nameVal,
    required String nimVal,
    String? status,
    bool isVerified = false,
    bool isError = false,
    bool isDashed = false,
  }) {
    Color borderColor = Colors.transparent;
    if (isError) borderColor = const Color(0xFFE53935);
    if (isDashed) borderColor = AppColors.outlineVariant;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDashed ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withOpacity(isDashed ? 1 : 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.captionBold.copyWith(color: AppColors.outline)),
              Icon(isDashed ? Icons.delete_outline : Icons.delete, color: isDashed ? AppColors.outline : const Color(0xFFE53935), size: 18),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('NAMA LENGKAP', style: AppTypography.captionBold.copyWith(fontSize: 10, color: AppColors.outline)),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: isDashed ? const Color(0xFFF9FAFB) : Colors.transparent,
              border: Border.all(color: AppColors.outlineVariant),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              initialValue: nameVal,
              enabled: !isDashed,
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('NOMOR INDUK MAHASISWA (NIM)', style: AppTypography.captionBold.copyWith(fontSize: 10, color: AppColors.outline)),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: isDashed ? const Color(0xFFF9FAFB) : Colors.transparent,
              border: Border.all(color: isError ? const Color(0xFFE53935) : AppColors.outlineVariant),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              initialValue: nimVal,
              enabled: !isDashed,
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
          if (status != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isVerified ? Icons.check_circle : Icons.error,
                  color: isVerified ? const Color(0xFF009688) : const Color(0xFFE53935),
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  status,
                  style: AppTypography.captionBold.copyWith(
                    fontSize: 10,
                    color: isVerified ? const Color(0xFF009688) : const Color(0xFFE53935),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption.copyWith(fontSize: 9, color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primary800)),
      ],
    );
  }

  Widget _buildSummaryItemWithBadge(String label, String value, String badgeText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption.copyWith(fontSize: 9, color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primary800)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary800,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(badgeText, style: AppTypography.captionBold.copyWith(fontSize: 8, color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCandidateSummaryItem(String init, String name, String detail) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.primary800,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(init, style: AppTypography.captionBold.copyWith(color: Colors.white)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary800)),
              Text(detail, style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.textSecondary)),
            ],
          ),
        ),
        const Icon(Icons.info_outline, color: AppColors.outline, size: 20),
      ],
    );
  }

  Widget _buildPrimaryButton({required String text, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.goldDark,
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Color(0xFFD4A030), Color(0xFFB38622)],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.goldMid.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}
