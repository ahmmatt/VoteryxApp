import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/kyc_nik_input_screen.dart';
import '../../features/auth/presentation/screens/kyc_method_select_screen.dart';
import '../../features/auth/presentation/screens/kyc_nfc_scan_screen.dart';
import '../../features/auth/presentation/screens/kyc_nfc_failed_screen.dart';
import '../../features/auth/presentation/screens/kyc_camera_screen.dart';
import '../../features/auth/presentation/screens/kyc_photo_error_screen.dart';
import '../../features/auth/presentation/screens/kyc_photo_review_screen.dart';
import '../../features/auth/presentation/screens/kyc_liveness_screen.dart';
import '../../features/auth/presentation/screens/kyc_liveness_failed_screen.dart';
import '../../features/user/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/user/election/presentation/screens/candidate_detail_screen.dart';
import '../../features/user/election/presentation/screens/vote_confirmation_screen.dart';
import '../../features/user/election/presentation/screens/vote_processing_screen.dart';
import '../../features/user/election/presentation/screens/vote_receipt_screen.dart';
import '../../features/user/delegation/presentation/screens/delegation_screen.dart';
import '../../features/delegates/delegation/presentation/screens/delegate_terms_screen.dart';
import '../../features/delegates/delegation/presentation/screens/delegate_registration_form_screen.dart';
import '../../features/delegates/delegation/presentation/screens/delegate_portal_login_screen.dart';
import '../../features/delegates/delegation/presentation/screens/delegate_review_screen.dart';
import '../../features/delegates/delegation/presentation/screens/delegate_approved_screen.dart';
import '../../features/delegates/delegation/presentation/screens/delegate_dashboard_screen.dart';
import '../../features/delegates/delegation/presentation/screens/delegate_home_screen.dart';
import '../../features/delegates/delegation/presentation/screens/delegate_vote_execution_screen.dart';
import '../../features/delegates/delegation/presentation/screens/delegate_vote_processing_screen.dart';
import '../../features/delegates/delegation/presentation/screens/delegate_vote_success_screen.dart';
import '../../features/delegates/delegation/presentation/screens/delegate_execution_history_screen.dart';
import '../../features/delegates/delegation/presentation/screens/delegate_detail_screen.dart';
import '../../features/delegates/delegation/presentation/screens/mandator_profile_screen.dart';
import '../../features/user/profile/presentation/screens/profile_screen.dart';
import '../../features/user/election/presentation/screens/election_detail_screen.dart';
import '../../features/user/election/presentation/screens/election_info_screen.dart';
import '../../features/user/election/presentation/screens/election_list_screen.dart';
import '../../features/user/election/presentation/screens/proposal_create_screen.dart';
import '../../features/user/election_proposal/presentation/screens/my_election_proposals_screen.dart';
import '../../features/user/election_proposal/presentation/screens/proposal_candidate_list_screen.dart';
import '../../features/user/election_proposal/presentation/screens/proposal_manage_schedule_screen.dart';
import '../../features/user/election_proposal/presentation/screens/proposal_track_detail_screen.dart';
import '../../features/delegates/profile/presentation/screens/delegate_profile_screen.dart';

// Admin Imports
import '../../features/admin/dashboard/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/election_management/presentation/screens/admin_proposal_monitor_screen.dart';
import '../../features/admin/election_management/presentation/screens/admin_create_election_candidates_screen.dart';
import '../../features/admin/election_management/presentation/screens/admin_create_election_review_screen.dart';
import '../../features/admin/election_management/presentation/screens/admin_inbox_usulan_screen.dart';
import '../../features/admin/election_management/presentation/screens/admin_proposal_candidate_list_screen.dart';
import '../../features/admin/election_management/presentation/screens/admin_proposal_track_detail_screen.dart';
import '../../features/admin/election_management/presentation/screens/admin_review_detail_screen.dart';
import '../../features/admin/candidate_management/presentation/screens/admin_candidate_management_screen.dart';
import '../../features/admin/candidate_verification/presentation/screens/admin_candidate_verification_screen.dart';
import '../../features/admin/candidate_verification/presentation/screens/admin_candidate_documents_screen.dart';
import '../../features/admin/candidate_verification/presentation/screens/admin_candidate_review_screen.dart';
import '../../features/admin/voter_management/presentation/screens/admin_voter_management_screen.dart';
import '../../features/admin/settings/presentation/screens/admin_settings_screen.dart';
import '../../features/admin/election_detail/presentation/screens/admin_election_live_detail_screen.dart';
import '../../features/admin/election_detail/presentation/screens/admin_election_draft_detail_screen.dart';
import '../../features/admin/election_detail/presentation/screens/admin_election_list_screen.dart';
import '../../features/admin/audit_log/presentation/screens/admin_kyc_dispute_screen.dart';
import '../../features/admin/delegate_management/presentation/screens/admin_delegate_applications_screen.dart';
import '../../features/admin/delegate_management/presentation/screens/admin_delegate_review_screen.dart';

// Layout Imports
import '../widgets/layouts/user_main_layout.dart';
import '../widgets/layouts/admin_main_layout.dart';
import '../widgets/layouts/delegate_main_layout.dart';

// ── Route path constants ──────────────────────────────────────────────────────
abstract final class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';

  static const kycNikInput = '/kyc/nik-input';
  static const kycMethodSelect = '/kyc/method-select';
  static const kycLiveness = '/kyc/liveness';
  static const kycNfcScan = '/kyc/nfc-scan';

  static const dashboard = '/dashboard';
  static const profile = '/profile';
  static const settings = '/settings';
  static const security = '/security';
  static const history = '/history';
  static const notification = '/notification';
  static const proposalStatus = '/proposal-status';
  static const proposalCreate = '/proposal-create';
  static const proposalCandidates = '/election-proposal/:id/candidates';
  static const proposalSchedule = '/election-proposal/:id/schedule';
  static const proposalTrack = '/election-proposal/:id/track';

  // Election — :id adalah UUID pemilihan
  static const electionList = '/elections';
  static const electionInfo = '/election-info/:id';
  static const electionDetail = '/election/:id';
  static const electionCandidate = '/election/:id/candidate/:candidateId';
  static const electionVote = '/election/:id/vote-execution';
  static const electionProcessing = '/election/:id/processing';
  static const electionReceipt = '/election/:id/receipt';

  // Delegation
  static const delegation = '/delegation';
  static const delegationDetail = '/delegation/:delegatorId';

  // Admin
  static const adminDashboard = '/admin/dashboard';
  static const adminProposals = '/admin/proposals';
  static const adminProposalTrack = '/admin/proposals/:id/track';
  static const adminProposalCandidates = '/admin/proposals/:id/candidates';
  static const adminInboxUsulan = '/admin/inbox-usulan';
  static const adminReviewDetail = '/admin/review-detail';
  static const adminCreateCandidates = '/admin/elections/create/candidates';
  static const adminCreateReview = '/admin/elections/create/review';
  static const adminCandidateManage = '/admin/candidates/manage';
  static const adminCandidateVerification = '/admin/candidate-verification';
  static const adminCandidateDocuments = '/admin/candidate-verification/:id/documents';
  static const adminCandidateReview = '/admin/candidate-verification/:id/review';
  static const adminVoters = '/admin/voters';
  static const adminSettings = '/admin/settings';
  static const adminElectionLive = '/admin/election/live/:id';
  static const adminElectionDraft = '/admin/election/draft/:id';
  static const adminElectionList = '/admin/elections';
  static const adminKycDispute = '/admin/kyc-dispute';
  static const adminDelegateApplications = '/admin/delegate-applications';
  static const adminDelegateReview = '/admin/delegate-review/:id';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');

// User branches keys
final GlobalKey<NavigatorState> _userDashboardBranchKey = GlobalKey<NavigatorState>(debugLabel: 'userDashboardBranch');
final GlobalKey<NavigatorState> _userDelegationBranchKey = GlobalKey<NavigatorState>(debugLabel: 'userDelegationBranch');
final GlobalKey<NavigatorState> _userProposalBranchKey = GlobalKey<NavigatorState>(debugLabel: 'userProposalBranch');
final GlobalKey<NavigatorState> _userProfileBranchKey = GlobalKey<NavigatorState>(debugLabel: 'userProfileBranch');

// Admin branches keys
final GlobalKey<NavigatorState> _adminDashboardBranchKey = GlobalKey<NavigatorState>(debugLabel: 'adminDashboardBranch');
final GlobalKey<NavigatorState> _adminProposalsBranchKey = GlobalKey<NavigatorState>(debugLabel: 'adminProposalsBranch');
final GlobalKey<NavigatorState> _adminDelegateAppsBranchKey = GlobalKey<NavigatorState>(debugLabel: 'adminDelegateAppsBranch');
final GlobalKey<NavigatorState> _adminSettingsBranchKey = GlobalKey<NavigatorState>(debugLabel: 'adminSettingsBranch');

// Delegate branches keys
final GlobalKey<NavigatorState> _delegateHomeBranchKey = GlobalKey<NavigatorState>(debugLabel: 'delegateHomeBranch');
final GlobalKey<NavigatorState> _delegateHistoryBranchKey = GlobalKey<NavigatorState>(debugLabel: 'delegateHistoryBranch');
final GlobalKey<NavigatorState> _delegateProfileBranchKey = GlobalKey<NavigatorState>(debugLabel: 'delegateProfileBranch');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  refreshListenable: _GoRouterRefreshStream(Supabase.instance.client.auth.onAuthStateChange),
  // ── Navigation Guard ──────────────────────────────────────────────────────
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final location = state.matchedLocation;

    // Routes yang boleh diakses tanpa login
    const publicRoutes = [
      '/splash',
      '/onboarding',
      '/login',
      '/kyc',
    ];

    final isPublicRoute = publicRoutes.any(
      (r) => location == r || location.startsWith(r),
    );

    // ── Dev Bypass Check ──
    if (LoginNotifier.isDevAdminBypass) {
      if (location == '/splash' ||
          location == '/onboarding' ||
          location == '/login') {
        return AppRoutes.adminDashboard;
      }
      return null;
    }

    // Belum login dan akses route protected → redirect ke login
    if (session == null && !isPublicRoute) {
      return AppRoutes.login;
    }

    // Sudah login dan akses splash/onboarding/login → redirect ke dashboard
    if (session != null &&
        (location == '/splash' ||
            location == '/onboarding' ||
            location == '/login')) {
      return AppRoutes.dashboard;
    }

    return null; // Tidak ada redirect
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (_, __) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.kycNikInput,
      name: 'kyc-nik-input',
      builder: (_, __) => const KycNikInputScreen(),
    ),
    GoRoute(
      path: AppRoutes.kycMethodSelect,
      name: 'kyc-method-select',
      builder: (_, __) => const KycMethodSelectScreen(),
    ),
    GoRoute(
      path: AppRoutes.kycNfcScan,
      name: 'kyc-nfc-scan',
      builder: (_, __) => const KycNfcScanScreen(),
    ),
    GoRoute(
      path: AppRoutes.kycLiveness,
      name: 'kyc-liveness',
      builder: (_, __) => const KycLivenessScreen(),
    ),
    GoRoute(
      path: '/kyc/nfc-failed',
      name: 'kyc-nfc-failed',
      builder: (_, __) => const KycNfcFailedScreen(),
    ),
    GoRoute(
      path: '/kyc/camera',
      name: 'kyc-camera',
      builder: (_, __) => const KycCameraScreen(),
    ),
    GoRoute(
      path: '/kyc/photo-error',
      name: 'kyc-photo-error',
      builder: (_, __) => const KycPhotoErrorScreen(),
    ),
    GoRoute(
      path: '/kyc/photo-review',
      name: 'kyc-photo-review',
      builder: (_, __) => const KycPhotoReviewScreen(),
    ),
    GoRoute(
      path: '/kyc/liveness-failed',
      name: 'kyc-liveness-failed',
      builder: (_, __) => const KycLivenessFailedScreen(),
    ),

    // ==========================================
    // USER ROLE ROUTES (with Bottom Navigation)
    // ==========================================
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return UserMainLayout(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _userDashboardBranchKey,
          routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              name: 'dashboard',
              pageBuilder: (context, state) => const NoTransitionPage<void>(
                key: ValueKey('user-dashboard-page'),
                child: DashboardScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _userDelegationBranchKey,
          routes: [
            GoRoute(
              path: AppRoutes.delegation,
              name: 'delegation',
              pageBuilder: (context, state) => const NoTransitionPage<void>(
                key: ValueKey('user-delegation-page'),
                child: DelegationScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _userProposalBranchKey,
          routes: [
            GoRoute(
              path: AppRoutes.proposalStatus,
              name: 'proposal-status',
              pageBuilder: (context, state) => const NoTransitionPage<void>(
                key: ValueKey('user-proposal-page'),
                child: MyElectionProposalsScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _userProfileBranchKey,
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              name: 'profile',
              pageBuilder: (context, state) => const NoTransitionPage<void>(
                key: ValueKey('user-profile-page'),
                child: ProfileScreen(),
              ),
            ),
          ],
        ),
      ],
    ),

    // ==========================================
    // ADMIN ROLE ROUTES (with Bottom Navigation)
    // ==========================================
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AdminMainLayout(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _adminDashboardBranchKey,
          routes: [
            GoRoute(
              path: AppRoutes.adminDashboard,
              name: 'admin-dashboard',
              pageBuilder: (context, state) => const NoTransitionPage<void>(
                key: ValueKey('admin-dashboard-page'),
                child: AdminDashboardScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _adminProposalsBranchKey,
          routes: [
            GoRoute(
              path: AppRoutes.adminProposals,
              name: 'admin-proposals',
              pageBuilder: (context, state) => const NoTransitionPage<void>(
                key: ValueKey('admin-proposals-page'),
                child: AdminProposalMonitorScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _adminDelegateAppsBranchKey,
          routes: [
            GoRoute(
              path: AppRoutes.adminDelegateApplications,
              name: 'admin-delegate-applications',
              pageBuilder: (context, state) => const NoTransitionPage<void>(
                key: ValueKey('admin-delegate-applications-page'),
                child: AdminDelegateApplicationsScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _adminSettingsBranchKey,
          routes: [
            GoRoute(
              path: AppRoutes.adminSettings,
              name: 'admin-settings',
              pageBuilder: (context, state) => const NoTransitionPage<void>(
                key: ValueKey('admin-settings-page'),
                child: AdminSettingsScreen(),
              ),
            ),
          ],
        ),
      ],
    ),

    // ==========================================
    // DELEGATE ROLE ROUTES (with Bottom Navigation)
    // ==========================================
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return DelegateMainLayout(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _delegateHomeBranchKey,
          routes: [
            GoRoute(
              path: '/delegation/home',
              name: 'delegate-home',
              pageBuilder: (context, state) => const NoTransitionPage<void>(
                key: ValueKey('delegate-home-page'),
                child: DelegateHomeScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _delegateHistoryBranchKey,
          routes: [
            GoRoute(
              path: '/delegation/history',
              name: 'delegate-history',
              pageBuilder: (context, state) => const NoTransitionPage<void>(
                key: ValueKey('delegate-history-page'),
                child: DelegateExecutionHistoryScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _delegateProfileBranchKey,
          routes: [
            GoRoute(
              path: '/delegation/profile/me',
              name: 'delegate-profile',
              pageBuilder: (context, state) => const NoTransitionPage<void>(
                key: ValueKey('delegate-profile-page'),
                child: DelegateProfileScreen(),
              ),
            ),
          ],
        ),
      ],
    ),

    // ==========================================
    // GLOBAL SUB-ROUTES (Without Bottom Nav)
    // ==========================================
    GoRoute(
      path: AppRoutes.electionList,
      name: 'elections',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const ElectionListScreen(),
    ),
    GoRoute(
      path: AppRoutes.electionInfo,
      name: 'election-info',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (ctx, state) => ElectionInfoScreen(
        electionId: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      path: AppRoutes.electionDetail,
      name: 'election',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (ctx, state) => ElectionDetailScreen(
        electionId: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      path: AppRoutes.electionCandidate,
      name: 'election-candidate',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => CandidateDetailScreen(
        electionId: state.pathParameters['id'] ?? '',
        candidateId: state.pathParameters['candidateId'] ?? '',
      ),
    ),
    GoRoute(
      path: AppRoutes.electionVote,
      name: 'election-vote',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const VoteConfirmationScreen(),
    ),
    GoRoute(
      path: AppRoutes.electionProcessing,
      name: 'election-processing',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const VoteProcessingScreen(),
    ),
    GoRoute(
      path: AppRoutes.electionReceipt,
      name: 'election-receipt',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const VoteReceiptScreen(),
    ),

    GoRoute(
      path: AppRoutes.proposalCreate,
      name: 'proposal-create',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (ctx, state) => const ProposalCreateScreen(),
    ),
    GoRoute(
      path: AppRoutes.proposalCandidates,
      name: 'proposal-candidates',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (ctx, state) => const ProposalCandidateListScreen(),
    ),
    GoRoute(
      path: AppRoutes.proposalSchedule,
      name: 'proposal-schedule',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (ctx, state) => const ProposalManageScheduleScreen(),
    ),
    GoRoute(
      path: AppRoutes.proposalTrack,
      name: 'proposal-track',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (ctx, state) => const ProposalTrackDetailScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminProposalTrack,
      name: 'admin-proposal-track',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (ctx, state) => const AdminProposalTrackDetailScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminProposalCandidates,
      name: 'admin-proposal-candidates',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (ctx, state) => const AdminProposalCandidateListScreen(),
    ),

    // Delegate non-nav routes
    GoRoute(
      path: '/delegation/dashboard',
      name: 'delegate-dashboard',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const DelegateDashboardScreen(),
    ),
    GoRoute(
      path: '/delegation/mandator-detail',
      name: 'delegate-detail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const DelegateDetailScreen(),
    ),
    GoRoute(
      path: '/delegation/mandator/:name',
      name: 'mandator-profile',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (ctx, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return MandatorProfileScreen(
          name: extra['name'] as String? ?? 'Mandator',
          nim: extra['nim'] as String? ?? '-',
          faculty: extra['faculty'] as String? ?? '-',
          status: extra['status'] as String? ?? 'Aktif',
          statusColor:
              extra['statusColor'] as Color? ?? const Color(0xFF10B981),
          votes: extra['votes'] as int? ?? 1,
          isRevoked: extra['isRevoked'] as bool? ?? false,
          imageUrl: extra['imageUrl'] as String? ?? 'https://i.pravatar.cc/150',
        );
      },
    ),
    GoRoute(
      path: '/delegation/login',
      name: 'delegate-login',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const DelegatePortalLoginScreen(),
    ),
    GoRoute(
      path: '/delegation/terms',
      name: 'delegate-terms',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const DelegateTermsScreen(),
    ),
    GoRoute(
      path: '/delegation/registration',
      name: 'delegate-registration',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const DelegateRegistrationFormScreen(),
    ),
    GoRoute(
      path: '/delegation/review',
      name: 'delegate-review',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const DelegateReviewScreen(),
    ),
    GoRoute(
      path: '/delegation/approved',
      name: 'delegate-approved',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const DelegateApprovedScreen(),
    ),
    GoRoute(
      path: '/delegation/vote-execution',
      name: 'delegate-vote-execution',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const DelegateVoteExecutionScreen(),
    ),
    GoRoute(
      path: '/delegation/vote-processing',
      name: 'delegate-vote-processing',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const DelegateVoteProcessingScreen(),
    ),
    GoRoute(
      path: '/delegation/vote-success',
      name: 'delegate-vote-success',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const DelegateVoteSuccessScreen(),
    ),
    GoRoute(
      path: '/delegation/:delegatorId',
      name: 'delegation-detail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (ctx, state) {
        final delegatorId = state.pathParameters['delegatorId'] ?? '';
        return _PlaceholderScreen(title: 'Delegasi dari: $delegatorId');
      },
    ),

    // Admin non-nav routes
    GoRoute(
      path: AppRoutes.adminCreateCandidates,
      name: 'admin-create-candidates',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const AdminCreateElectionCandidatesScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminCreateReview,
      name: 'admin-create-review',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const AdminCreateElectionReviewScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminCandidateManage,
      name: 'admin-candidate-manage',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const AdminCandidateManagementScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminCandidateVerification,
      name: 'admin-candidate-verification',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const AdminCandidateVerificationScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminCandidateDocuments,
      name: 'admin-candidate-documents',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) {
        final id = state.pathParameters['id'] ?? '';
        return AdminCandidateDocumentsScreen(candidateId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.adminCandidateReview,
      name: 'admin-candidate-review',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) {
        final id = state.pathParameters['id'] ?? '';
        return AdminCandidateReviewScreen(candidateId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.adminVoters,
      name: 'admin-voters',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const AdminVoterManagementScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminElectionLive,
      name: 'admin-election-live',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final id = state.pathParameters['id'] ?? extra?['id']?.toString() ?? '1';
        final title = extra?['title']?.toString();
        return AdminElectionLiveDetailScreen(electionId: id, electionTitle: title);
      },
    ),
    GoRoute(
      path: AppRoutes.adminElectionDraft,
      name: 'admin-election-draft',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const AdminElectionDraftDetailScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminInboxUsulan,
      name: 'admin-inbox-usulan',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const AdminInboxUsulanScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminReviewDetail,
      name: 'admin-review-detail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const AdminReviewDetailScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminElectionList,
      name: 'admin-election-list',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const AdminElectionListScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminKycDispute,
      name: 'admin-kyc-dispute',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const AdminKycDisputeScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminDelegateReview,
      name: 'admin-delegate-review',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (ctx, state) {
        final id = state.pathParameters['id'] ?? '';
        return AdminDelegateReviewScreen(id: id);
      },
    ),
  ],
  errorBuilder: (ctx, state) => _PlaceholderScreen(
    title: 'Halaman Tidak Ditemukan',
    subtitle: state.error?.message,
  ),
);

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
            Text(title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center),
            ],
            const SizedBox(height: 8),
            const Text('— Coming soon —',
                style: TextStyle(color: Color(0xFF75777E), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<AuthState> stream) {
    _subscription = stream.asBroadcastStream().listen((AuthState authState) {
      final event = authState.event;
      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.signedOut ||
          event == AuthChangeEvent.userDeleted) {
        notifyListeners();
      }
    });
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
