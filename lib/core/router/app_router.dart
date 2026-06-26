// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/election/presentation/screens/candidate_detail_screen.dart';
import '../../features/election/presentation/screens/vote_confirmation_screen.dart';
import '../../features/election/presentation/screens/vote_processing_screen.dart';
import '../../features/election/presentation/screens/vote_receipt_screen.dart';
import '../../features/delegation/presentation/screens/delegation_screen.dart';
import '../../features/delegation/presentation/screens/delegate_login_screen.dart';
import '../../features/delegation/presentation/screens/delegate_registration_form_screen.dart';
import '../../features/delegation/presentation/screens/delegate_review_screen.dart';
import '../../features/delegation/presentation/screens/delegate_approved_screen.dart';
import '../../features/delegation/presentation/screens/delegate_dashboard_screen.dart';
import '../../features/delegation/presentation/screens/delegate_home_screen.dart';
import '../../features/delegation/presentation/screens/delegate_vote_execution_screen.dart';
import '../../features/delegation/presentation/screens/delegate_vote_processing_screen.dart';
import '../../features/delegation/presentation/screens/delegate_vote_success_screen.dart';
import '../../features/delegation/presentation/screens/delegate_execution_history_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/election/presentation/screens/election_detail_screen.dart';
import '../../features/election/presentation/screens/proposal_create_screen.dart';
import '../../features/election_proposal/presentation/screens/my_election_proposals_screen.dart';


// ── Route path constants ──────────────────────────────────────────────────────
// Gunakan konstanta ini saat navigate agar tidak ada magic string.
// Contoh: context.go(AppRoutes.dashboard)
abstract final class AppRoutes {
  static const splash           = '/splash';
  static const onboarding       = '/onboarding';
  static const login            = '/login';

  static const kycNikInput      = '/kyc/nik-input';
  static const kycLiveness      = '/kyc/liveness';

  static const dashboard        = '/dashboard';

  // Election — :id adalah UUID pemilihan
  static const electionDetail   = '/election/:id';
  static const electionCandidate = '/election/:id/candidate/:candidateId';
  static const electionVote     = '/election/:id/vote-execution';
  static const electionProcessing = '/election/:id/processing';
  static const electionReceipt  = '/election/:id/receipt';

  // Delegation
  static const delegation       = '/delegation';
  static const delegationDetail = '/delegation/:delegatorId';

  // Profile
  static const profile          = '/profile';

  // Election Proposal (user/organisasi)
  static const proposalCreate   = '/election-proposal/create';
  static const proposalStatus   = '/election-proposal/status';
}

// ── Router instance ───────────────────────────────────────────────────────────

/// Router utama Voteryx.
///
/// Semua route saat ini mengarah ke [Placeholder] widget dan akan
/// diganti dengan screen sesungguhnya saat tiap feature dibangun.
///
/// Cara gunakan di [MaterialApp.router]:
/// ```dart
/// MaterialApp.router(routerConfig: appRouter)
/// ```
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.dashboard, // TODO: ganti ke /splash setelah flow selesai
  debugLogDiagnostics: true,
  routes: [
    // ── Auth & Onboarding ─────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (_, __) => const _PlaceholderScreen(title: 'Splash'),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (_, __) => const _PlaceholderScreen(title: 'Onboarding'),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (_, __) => const LoginScreen(),
    ),

    // ── KYC ──────────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.kycNikInput,
      name: 'kyc-nik-input',
      builder: (_, __) => const _PlaceholderScreen(title: 'KYC: Input NIK'),
    ),
    GoRoute(
      path: AppRoutes.kycLiveness,
      name: 'kyc-liveness',
      builder: (_, __) => const _PlaceholderScreen(title: 'KYC: Liveness'),
    ),

    // ── Dashboard ─────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.dashboard,
      name: 'dashboard',
      builder: (_, __) => const DashboardScreen(),
    ),

    // ── Election ──────────────────────────────────────────────────────
    GoRoute(
      path: '/election/:id',
      name: 'election',
      builder: (ctx, state) {
        return const ElectionDetailScreen();
      },
      routes: [
        GoRoute(
          path: 'candidate/:candidateId',
          name: 'election-candidate',
          builder: (_, __) => const CandidateDetailScreen(),
        ),
        GoRoute(
          path: 'vote-execution',
          name: 'election-vote',
          builder: (context, state) => const VoteConfirmationScreen(),
        ),
        GoRoute(
          path: 'processing',
          name: 'election-processing',
          builder: (context, state) => const VoteProcessingScreen(),
        ),
        GoRoute(
          path: 'receipt',
          name: 'election-receipt',
          builder: (context, state) => const VoteReceiptScreen(),
        ),
      ],
    ),

    // ── Delegation ────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.delegation,
      name: 'delegation',
      builder: (_, __) => const DelegationScreen(),
    ),
    GoRoute(
      path: '/delegation/login',
      name: 'delegate-login',
      builder: (_, __) => const DelegateLoginScreen(),
    ),
    GoRoute(
      path: '/delegation/registration',
      name: 'delegate-registration',
      builder: (_, __) => const DelegateRegistrationFormScreen(),
    ),
    GoRoute(
      path: '/delegation/review',
      name: 'delegate-review',
      builder: (_, __) => const DelegateReviewScreen(),
    ),
    GoRoute(
      path: '/delegation/approved',
      name: 'delegate-approved',
      builder: (_, __) => const DelegateApprovedScreen(),
    ),
    GoRoute(
      path: '/delegation/home',
      name: 'delegate-home',
      builder: (_, __) => const DelegateHomeScreen(),
    ),
    GoRoute(
      path: '/delegation/dashboard',
      name: 'delegate-dashboard',
      builder: (_, __) => const DelegateDashboardScreen(),
    ),
    GoRoute(
      path: '/delegation/vote-execution',
      name: 'delegate-vote-execution',
      builder: (_, __) => const DelegateVoteExecutionScreen(),
    ),
    GoRoute(
      path: '/delegation/vote-processing',
      name: 'delegate-vote-processing',
      builder: (_, __) => const DelegateVoteProcessingScreen(),
    ),
    GoRoute(
      path: '/delegation/vote-success',
      name: 'delegate-vote-success',
      builder: (_, __) => const DelegateVoteSuccessScreen(),
    ),
    GoRoute(
      path: '/delegation/history',
      name: 'delegate-history',
      builder: (_, __) => const DelegateExecutionHistoryScreen(),
    ),
    GoRoute(
      path: '/delegation/:delegatorId',
      name: 'delegation-detail',
      builder: (ctx, state) {
        final delegatorId = state.pathParameters['delegatorId'] ?? '';
        return _PlaceholderScreen(title: 'Delegasi dari: $delegatorId');
      },
    ),

    // ── Profile ───────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (_, __) => const ProfileScreen(),
    ),

    // ── Election Proposal ─────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.proposalCreate,
      name: 'proposal-create',
      builder: (_, __) => const ProposalCreateScreen(),
    ),
    GoRoute(
      path: AppRoutes.proposalStatus,
      name: 'proposal-status',
      builder: (_, __) => const MyElectionProposalsScreen(),
    ),
  ],

  // Global error handler
  errorBuilder: (ctx, state) => _PlaceholderScreen(
    title: 'Halaman Tidak Ditemukan',
    subtitle: state.error?.message,
  ),
);

// ── Placeholder screen ────────────────────────────────────────────────────────
/// Widget sementara untuk semua route yang belum diimplementasi.
/// Akan diganti dengan screen sesungguhnya secara bertahap.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction_outlined,
                size: 56, color: Color(0xFF9C7523)),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 8),
            const Text(
              '— Coming soon —',
              style: TextStyle(color: Color(0xFF75777E), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
