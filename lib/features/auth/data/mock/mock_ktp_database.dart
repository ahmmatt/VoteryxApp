// lib/features/auth/data/mock/mock_ktp_database.dart
import '../../presentation/providers/auth_provider.dart';

/// Database simulasi e-KTP pintar (Mock KTP Lookup Service)
/// Berisi data asli/realistis dari daftar kependudukan untuk simulasi pembacaan NFC dan OCR Kamera.
class MockKtpDatabase {
  static final Map<String, KtpData> _records = {
    '7307052504070001': const KtpData(
      nik: '7307052504070001',
      fullName: 'AHMAD HAMDAN. N',
      birthPlace: 'UJUNG PANDANG',
      birthDate: '31 Agustus 1976 (48 Tahun)',
      gender: 'Laki-laki',
      address: 'JL. NENAS NO. 10, RT 003 RW 001, BALANGNIPA, SINJAI UTARA',
    ),
    '7307051203090002': const KtpData(
      nik: '7307051203090002',
      fullName: 'AHMAD HAMKA',
      birthPlace: 'BANTAENG',
      birthDate: '28 November 1961 (63 Tahun)',
      gender: 'Laki-laki',
      address: 'JL. PRAMUKA NO. 5, RT 002 RW 003, BALANGNIPA, SINJAI UTARA',
    ),
    '7307081111160001': const KtpData(
      nik: '7307081111160001',
      fullName: 'AHMAD HAMSAH',
      birthPlace: 'BONTOMANAI',
      birthDate: '7 Juli 1980 (44 Tahun)',
      gender: 'Laki-laki',
      address: 'DUSUN BONTO ASA, RT 001 RW 001, MANNANTO, TELLU LIMPOE',
    ),
    '7307091503070213': const KtpData(
      nik: '7307091503070213',
      fullName: 'AHMAD HANAFI',
      birthPlace: 'P.KAMBUNO',
      birthDate: '7 April 2005 (19 Tahun)',
      gender: 'Laki-laki',
      address: 'PULAU KAMBUNO, RT 002 RW 002, PULAU HARAPAN, PULAU SEMBILAN',
    ),
    '7307052501190001': const KtpData(
      nik: '7307052501190001',
      fullName: 'AHMAD HASYIM',
      birthPlace: 'UJUNG PANDANG',
      birthDate: '30 Juli 1978 (46 Tahun)',
      gender: 'Laki-laki',
      address: 'JL. AMANAGAPPA NO. 12, RT 003 RW 003, LAPPA, SINJAI UTARA',
    ),
    '7307051202180008': const KtpData(
      nik: '7307051202180008',
      fullName: 'AHMAD HAZIMUL FIKRI',
      birthPlace: 'SINJAI',
      birthDate: '20 Agustus 2007 (17 Tahun)',
      gender: 'Laki-laki',
      address: 'JL. KALAMPETO, RT 002 RW 002, BALANGNIPA, SINJAI UTARA',
    ),
    '7307022901053067': const KtpData(
      nik: '7307022901053067',
      fullName: 'AHMAD HIDAYAT',
      birthPlace: 'SINJAI',
      birthDate: '5 Mei 2002 (22 Tahun)',
      gender: 'Laki-laki',
      address: 'BOLA ROMANO, RT 002 RW 006, SANGIASSERI, SINJAI SELATAN',
    ),
    '7307082901052792': const KtpData(
      nik: '7307082901052792',
      fullName: 'AHMAD HIDAYAT',
      birthPlace: 'SINJAI',
      birthDate: '27 Januari 2005 (19 Tahun)',
      gender: 'Laki-laki',
      address: 'BONTO ASA, RT 002 RW 005, MANNANTO, TELLU LIMPOE',
    ),
    '7307032603070121': const KtpData(
      nik: '7307032603070121',
      fullName: 'AHMAD HIDAYAT',
      birthPlace: 'SINJAI',
      birthDate: '18 April 2001 (23 Tahun)',
      gender: 'Laki-laki',
      address: 'CEMPAE, RT 001 RW 003, TONGKE-TONGKE, SINJAI TIMUR',
    ),
    '7307051603230000': const KtpData(
      nik: '7307051603230000',
      fullName: 'AHMAD HIDAYAT',
      birthPlace: 'TOBUNNE',
      birthDate: '1 Juli 2000 (24 Tahun)',
      gender: 'Laki-laki',
      address: 'JL. A.P. PETTA RANI, RT 003 RW 003, BALANGNIPA, SINJAI UTARA',
    ),
    '73070712180001': const KtpData(
      nik: '73070712180001',
      fullName: 'AHMAD HIDAYAT',
      birthPlace: 'BULUKUMBA',
      birthDate: '21 April 1994 (30 Tahun)',
      gender: 'Laki-laki',
      address: 'MACCINI, RT 004 RW 004, BONTO TENGNGA, SINJAI BORONG',
    ),
    '7307023010170001': const KtpData(
      nik: '7307023010170001',
      fullName: 'AHMAD HIDAYAT',
      birthPlace: 'SINJAI',
      birthDate: '11 Oktober 1986 (38 Tahun)',
      gender: 'Laki-laki',
      address: 'MATTOANGING, RT 001 RW 002, SONGING, SINJAI SELATAN',
    ),
    '7307051808170002': const KtpData(
      nik: '7307051808170002',
      fullName: 'AHMAD HIDAYAT KURNIAWAN',
      birthPlace: 'SINJAI',
      birthDate: '4 Oktober 1992 (32 Tahun)',
      gender: 'Laki-laki',
      address: 'JL. CUMI CUMI, RT 000 RW 012, LAPPA, SINJAI UTARA',
    ),
    '7307012901051963': const KtpData(
      nik: '7307012901051963',
      fullName: 'AHMAD HIDAYATULLAH',
      birthPlace: 'SINJAI',
      birthDate: '7 Juli 2006 (18 Tahun)',
      gender: 'Laki-laki',
      address: 'BONTO SUNGGU, RT 001 RW 004, TERASA, SINJAI BARAT',
    ),
    '7307092702090005': const KtpData(
      nik: '7307092702090005',
      fullName: 'AHMAD HISFA',
      birthPlace: 'SINJAI',
      birthDate: '31 Desember 1971 (53 Tahun)',
      gender: 'Laki-laki',
      address: 'KANALO I, RT 001 RW 001, PULAU PERSATUAN, PULAU SEMBILAN',
    ),
    '7307052405220002': const KtpData(
      nik: '7307052405220002',
      fullName: 'AHMAD HUDZAIFAH',
      birthPlace: 'SINJAI',
      birthDate: '17 Maret 1994 (30 Tahun)',
      gender: 'Laki-laki',
      address: 'JL. R.A. KARTINI NO. 6, RT 001 RW 001, BIRINGERE, SINJAI UTARA',
    ),
    '7307022901053825': const KtpData(
      nik: '7307022901053825',
      fullName: 'AHMAD HUMAEDI',
      birthPlace: 'SINJAI',
      birthDate: '25 September 2005 (19 Tahun)',
      gender: 'Laki-laki',
      address: 'DUSUN LITA - LITAE, RT 001 RW 001, GARECCING, SINJAI SELATAN',
    ),
    '7307052010200008': const KtpData(
      nik: '7307052010200008',
      fullName: 'AHMAD HUMAIDI',
      birthPlace: 'MAKASSAR',
      birthDate: '30 Oktober 2000 (24 Tahun)',
      gender: 'Laki-laki',
      address: 'JL. GUNUNG RINJANI NO. 1, RT 002 RW 009, BONGKI, SINJAI UTARA',
    ),
    '7307052901050579': const KtpData(
      nik: '7307052901050579',
      fullName: 'AHMAD HUMAN TAP',
      birthPlace: 'SINJAI',
      birthDate: '29 Mei 1994 (30 Tahun)',
      gender: 'Laki-laki',
      address: 'JL. JEND. SUDIRMAN NO. 10, RT 003 RW 008, BIRINGERE, SINJAI UTARA',
    ),
    '7307062901051525': const KtpData(
      nik: '7307062901051525',
      fullName: 'AHMAD HUSAIN',
      birthPlace: 'SINJAI',
      birthDate: '20 Oktober 2003 (21 Tahun)',
      gender: 'Laki-laki',
      address: 'DUSUN SATENGNGA, RT 001 RW 006, BULU TELLUE, BULUPODDO',
    ),
    '7307052511080003': const KtpData(
      nik: '7307052511080003',
      fullName: 'AHMAD HUSAIN',
      birthPlace: 'SINJAI',
      birthDate: '15 Desember 1958 (66 Tahun)',
      gender: 'Laki-laki',
      address: 'JL. SULTAN HASANUDDIN, RT 003 RW 004, BALANGNIPA, SINJAI UTARA',
    ),
    '7307031101180002': const KtpData(
      nik: '7307031101180002',
      fullName: 'AHMAD ICHSAN MAULANA',
      birthPlace: 'SINJAI',
      birthDate: '26 Desember 1992 (32 Tahun)',
      gender: 'Laki-laki',
      address: 'DUSUN BIRORO, RT 002 RW 002, BIRORO, SINJAI TIMUR',
    ),
    '7307022901052723': const KtpData(
      nik: '7307022901052723',
      fullName: 'AHMAD IDRIS DG. SL',
      birthPlace: 'SINJAI',
      birthDate: '1 Juli 1950 (74 Tahun)',
      gender: 'Laki-laki',
      address: 'CAILE, RT 001 RW 002, SANGIASSERI, SINJAI SELATAN',
    ),
    '7307052901050762': const KtpData(
      nik: '7307052901050762',
      fullName: 'AHMAD IDRIS M.A',
      birthPlace: 'PALEMBANG',
      birthDate: '18 Februari 1973 (51 Tahun)',
      gender: 'Laki-laki',
      address: 'JL. SYARIF AL QADRI, RT 001 RW 017, BALANGNIPA, SINJAI UTARA',
    ),
    '7307030804080035': const KtpData(
      nik: '7307030804080035',
      fullName: 'AHMAD IHSAN',
      birthPlace: 'SINJAI',
      birthDate: '1 Januari 1999 (25 Tahun)',
      gender: 'Laki-laki',
      address: 'BIRORO, RT 002 RW 001, BIRORO, SINJAI TIMUR',
    ),
    '7307042901050769': const KtpData(
      nik: '7307042901050769',
      fullName: 'AHMAD IKHSAN',
      birthPlace: 'SINJAI',
      birthDate: '6 Juni 2005 (19 Tahun)',
      gender: 'Laki-laki',
      address: 'DUSUN BONTO PENNO, RT 001 RW 002, MATTUNRENG TELLUE, SINJAI TENGAH',
    ),
    '7307042901050511': const KtpData(
      nik: '7307042901050511',
      fullName: 'AHMAD ILHAM',
      birthPlace: 'SINJAI',
      birthDate: '21 Juli 1988 (36 Tahun)',
      gender: 'Laki-laki',
      address: 'DUSUN BONGKONO, RT 001 RW 002, SAMAENRE, SINJAI TENGAH',
    ),
    '7307052710200001': const KtpData(
      nik: '7307052710200001',
      fullName: 'AHMAD IRFANDI',
      birthPlace: 'BULUKUMBA',
      birthDate: '5 Oktober 1987 (37 Tahun)',
      gender: 'Laki-laki',
      address: 'BTN LAPPA MAS BLOK D NO. 5, RT 003 RW 018, LAPPA, SINJAI UTARA',
    ),
    '7307012901054375': const KtpData(
      nik: '7307012901054375',
      fullName: 'AHMAD IRFANDI',
      birthPlace: 'SINJAI',
      birthDate: '29 November 1998 (26 Tahun)',
      gender: 'Laki-laki',
      address: 'LEMBANNA, RT 001 RW 002, GUNUNG PERAK, SINJAI BARAT',
    ),
    '7307050805230002': const KtpData(
      nik: '7307050805230002',
      fullName: 'AHMAD IRVAN',
      birthPlace: 'MARGOMULYO',
      birthDate: '11 Juni 1998 (26 Tahun)',
      gender: 'Laki-laki',
      address: 'JL. SUNGAI TANGKA, RT 001 RW 011, BALANGNIPA, SINJAI UTARA',
    ),
  };

  /// Mencari data e-KTP berdasarkan NIK.
  /// Jika NIK ada di tabel database simulasi, akan mengembalikan data pasti.
  /// Jika tidak ada, akan membuat data simulasi realistis (fallback).
  static KtpData lookupByNik(String nik, {String? ktpImagePath}) {
    final cleanNik = nik.replaceAll(RegExp(r'\D'), '');
    final match = _records[cleanNik];

    if (match != null) {
      return KtpData(
        nik: match.nik,
        fullName: match.fullName,
        birthPlace: match.birthPlace,
        birthDate: match.birthDate,
        gender: match.gender,
        address: match.address,
        ktpImagePath: ktpImagePath,
      );
    }

    // Fallback realistis jika NIK lain yang diketik
    return KtpData(
      nik: cleanNik.isEmpty ? '7307052504070001' : cleanNik,
      fullName: 'WARGA KABUPATEN SINJAI',
      birthPlace: 'SINJAI',
      birthDate: '15 Mei 2003 (21 Tahun)',
      gender: 'Laki-laki',
      address: 'JL. JENDERAL SUDIRMAN NO. 1, BALANGNIPA, SINJAI UTARA',
      ktpImagePath: ktpImagePath,
    );
  }
}
