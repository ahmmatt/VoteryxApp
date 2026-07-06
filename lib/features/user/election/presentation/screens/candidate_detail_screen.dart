import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/widgets/gold_button.dart';

class CandidateDetailScreen extends StatefulWidget {
  const CandidateDetailScreen({super.key});

  @override
  State<CandidateDetailScreen> createState() => _CandidateDetailScreenState();
}

class _CandidateDetailScreenState extends State<CandidateDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          NestedScrollView(
            physics: const ClampingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 350,
                  pinned: true,
                  backgroundColor: AppColors.primary800,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/dashboard');
                      }
                    },
                  ),
                  titleSpacing: 0,
                  title: Text(
                    'Profil Kandidat',
                    style: AppTypography.headerTitle.copyWith(color: Colors.white),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.white, size: 20),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white, size: 20),
                      onPressed: () {},
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildProfileHeader(context),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(48),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        border: Border(
                          bottom: BorderSide(color: AppColors.outlineVariant, width: 1),
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        indicatorColor: AppColors.goldDark,
                        indicatorWeight: 3,
                        labelColor: AppColors.goldDark,
                        unselectedLabelColor: AppColors.textSecondary,
                        labelStyle: AppTypography.labelLarge,
                        unselectedLabelStyle: AppTypography.bodyMedium,
                        dividerColor: Colors.transparent,
                        tabs: const [
                          Tab(text: 'Visi & Misi'),
                          Tab(text: 'Track Record'),
                          Tab(text: 'Program Kerja'),
                          Tab(text: 'Statistik'),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildVisiMisiTab(),
                _buildTrackRecordTab(),
                _buildProgramKerjaTab(),
                _buildStatistikTab(),
              ],
            ),
          ),

          // Bottom Sticky Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      color: AppColors.primary800,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + kToolbarHeight + 16,
        bottom: 56,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avatar with No.02 badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFC5C6CE),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2), width: 4),
                ),
                child: const Icon(Icons.person,
                    size: 64, color: AppColors.textSecondary),
              ),
              Positioned(
                bottom: 0,
                right: -10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warningAmber,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    'No. 02',
                    style:
                        AppTypography.labelLarge.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Name and verified badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Faisal Ahmadi',
                style: AppTypography.displayHeading
                    .copyWith(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0x33139971),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.successTeal),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified,
                        color: AppColors.successTeal, size: 10),
                    const SizedBox(width: 4),
                    Text(
                      'Terverifikasi',
                      style: AppTypography.captionBold.copyWith(
                          color: AppColors.successTeal, fontSize: 8),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Subtitle
          Text(
            'Fakultas Hukum • Semester 6',
            style: AppTypography.bodyText
                .copyWith(color: Colors.white.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildVisiMisiTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      physics: const ClampingScrollPhysics(),
      children: [
        Text('Visi', style: AppTypography.screenTitle.copyWith(fontSize: 20)),
        const SizedBox(height: 12),
        Text(
          '"Mewujudkan universitas yang inklusif, transparan, dan berorientasi pada kesejahteraan mahasiswa melalui inovasi digital."',
          style: AppTypography.bodyText.copyWith(
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
              fontSize: 15),
        ),
        const SizedBox(height: 24),
        Text('Misi', style: AppTypography.screenTitle.copyWith(fontSize: 20)),
        const SizedBox(height: 12),
        _buildBulletPoint(
            'Digitalisasi seluruh layanan administrasi kemahasiswaan untuk efisiensi waktu.'),
        _buildBulletPoint(
            'Membangun transparansi anggaran organisasi kemahasiswaan yang dapat diakses publik.'),
        _buildBulletPoint(
            'Meningkatkan kuota beasiswa internal bagi mahasiswa berprestasi dan kurang mampu.'),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 12),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.goldDark,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyText
                  .copyWith(color: AppColors.textSecondary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackRecordTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      physics: const ClampingScrollPhysics(),
      children: [
        _buildTimelineItem(
          year: '2023 - SEKARANG',
          title: 'Ketua Himpunan Mahasiswa Hukum',
          description:
              'Memimpin 150+ anggota dan berhasil menyelenggarakan National Law Debate 2023 dengan peserta dari 30 universitas.',
          isFirst: true,
          isLast: false,
        ),
        _buildTimelineItem(
          year: '2022',
          title: 'Koordinator Advokasi Kampus',
          description:
              'Berhasil menegosiasikan penurunan biaya SPP bagi 200 mahasiswa terdampak ekonomi melalui program subsidi silang.',
          isFirst: false,
          isLast: false,
        ),
        _buildTimelineItem(
          year: '2021',
          title: 'Pertukaran Pelajar – NUS Singapore',
          description:
              'Terpilih sebagai salah satu dari 5 delegasi universitas untuk program studi banding kebijakan publik di Singapura.',
          isFirst: false,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String year,
    required String title,
    required String description,
    required bool isFirst,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline line and dot
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isFirst
                          ? AppColors.goldDark
                          : AppColors.outlineVariant,
                      width: 4,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    year,
                    style: AppTypography.captionBold.copyWith(
                      color: isFirst ? AppColors.goldDark : AppColors.outline,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: AppTypography.cardTitle.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: AppTypography.bodyText,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramKerjaTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      physics: const ClampingScrollPhysics(),
      children: [
        _buildProgramCard(
          title: 'Kampus Digital Terintegrasi',
          description:
              'Pengembangan aplikasi satu pintu untuk administrasi mahasiswa.',
        ),
        const SizedBox(height: 16),
        _buildProgramCard(
          title: 'Dana Hibah Riset Mandiri',
          description:
              'Alokasi dana 500jt per tahun untuk riset inovatif mahasiswa.',
        ),
      ],
    );
  }

  Widget _buildProgramCard({
    required String title,
    required String description,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x050F1F3D),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: const BoxDecoration(
            border:
                Border(left: BorderSide(color: AppColors.goldDark, width: 4)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppTypography.itemTitle.copyWith(fontSize: 16)),
              const SizedBox(height: 8),
              Text(description, style: AppTypography.bodyText),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatistikTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      physics: const ClampingScrollPhysics(),
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x050F1F3D),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Circular Chart
              SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const CircularProgressIndicator(
                      value: 0.82,
                      backgroundColor: Color(0xFFFEEFC3), // Light gold
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.goldMid),
                      strokeWidth: 8,
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '82%',
                            style: AppTypography.displayHeading
                                .copyWith(fontSize: 40),
                          ),
                          Text(
                            'Sentimen Positif',
                            style: AppTypography.captionBold
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('Dukungan',
                          style: AppTypography.captionBold
                              .copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text('4,203',
                          style: AppTypography.screenTitle
                              .copyWith(color: AppColors.goldDark)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Partisipasi',
                          style: AppTypography.captionBold
                              .copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text('12k', style: AppTypography.screenTitle),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.pagePad,
        right: AppSpacing.pagePad,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
        top: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background.withValues(alpha: 0.0),
            AppColors.background,
            AppColors.background,
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
      child: GoldButton(
        label: 'Pilih Kandidat No. 02',
        icon: Icons.arrow_forward,
        onPressed: () {
          context.pushNamed('election-vote', pathParameters: {'id': '1'});
        },
      ),
    );
  }
}
