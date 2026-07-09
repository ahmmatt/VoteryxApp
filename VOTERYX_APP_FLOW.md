# Voteryx — Dokumen Acuan Alur Aplikasi

> **Versi:** 2.0
> **Tipe:** Liquid Democracy E-Voting App untuk Pemilihan Kampus
> **Platform:** Flutter (Mobile) + Web Dashboard (Admin)
> **Terakhir diperbarui:** Juni 2026

Dokumen ini adalah acuan tunggal (single source of truth) untuk alur aplikasi, role, dan halaman Voteryx. Simpan di root project sebagai referensi tim saat development.

---

## 1. Konsep Inti: Liquid Democracy

Voteryx menggunakan model **Liquid Democracy** — perpaduan demokrasi langsung dan perwakilan. Setiap pemilih bisa memilih dua cara:

1. **Memilih langsung** — menggunakan 1 bobot suara miliknya sendiri
2. **Mendelegasikan suara** — mempercayakan bobot suaranya kepada seseorang yang dianggap lebih paham (Delegate), yang nantinya akan menggunakan bobot gabungan tersebut saat memilih

Prinsip yang dijaga ketat di seluruh sistem:
- Pilihan individu **selalu dienkripsi end-to-end** — tidak bisa dilihat siapa pun, termasuk Admin
- Delegate **tidak bisa mendelegasikan ulang** suara yang diterimanya (mencegah rantai delegasi tak terbatas)
- Delegasi **bisa dicabut** kapan saja selama pemilihan masih aktif

---

## 2. Role dalam Aplikasi

| Role | Deskripsi | Akses Utama |
|---|---|---|
| **User** | Mahasiswa terverifikasi, pemilih dasar | Memilih langsung, mendelegasikan suara, mengajukan usulan pemilihan |
| **Delegate** | User yang dipercaya menerima mandat suara dari User lain | Semua akses User + menerima mandat, eksekusi suara gabungan, profil publik |
| **Admin** | Penyelenggara pemilihan (BEM/HIMA/Panitia Pemilu) | Kelola pemilihan, kandidat, pemilih, hasil, audit — tanpa bisa melihat pilihan individu |

Catatan: setiap user pada dasarnya berstatus **User**. Status **Delegate** adalah peran tambahan yang didapat ketika ada pihak lain yang mendelegasikan suara padanya — bukan role terpisah yang didaftarkan manual.

---

## 3. Alur Aplikasi End-to-End (User Journey)

**Prinsip penting:** KYC (verifikasi identitas) hanya dilakukan **satu kali, saat Registrasi**. Setelah akun terverifikasi, Login berikutnya cukup menggunakan **NIK + Password** — tidak ada scan KTP/wajah ulang setiap kali membuka aplikasi.

```
Splash/Onboarding
      │
      ▼
 Punya akun? ──── Belum ────► REGISTRASI (lihat alur di bawah, hanya sekali)
      │                              │
     Ya                              ▼
      │                        Akun terverifikasi
      ▼                              │
    LOGIN ◄────────────────────────┘
 (NIK + Password)
      │
      ▼
  Dashboard (beda tampilan ringan sesuai role: User/Delegate)
      │
      ├──► Election Hub ──► Profil Kandidat ──► Eksekusi Suara ──► E-Receipt
      │
      ├──► Delegation Hub ──► Detail Delegator ──► Konfirmasi Delegasi ──► E-Receipt Delegasi
      │
      ├──► Ajukan Pemilihan Baru (alur 3 langkah) ──► Status Usulan
      │
      └──► Profil ──► Edit Profil / Riwayat / Pengaturan
```

### Alur Registrasi (KYC On-Device — hanya sekali)

```
1. Buat Akun
   Input NIK + buat Password baru
            │
            ▼
2. Cek dukungan NFC pada perangkat (otomatis)
            │
   ┌────────┴────────┐
   ▼                  ▼
HP mendukung NFC   HP TIDAK mendukung NFC
   │                  │
   ▼                  ▼
Tap e-KTP ke HP    Foto e-KTP manual
(baca chip NFC,    (kamera + frame guide,
data otomatis      OCR ekstrak data,
terisi)            user review/koreksi)
   │                  │
   └────────┬─────────┘
            ▼
3. Liveness Detection (scan wajah real-time + kedip)
   Dicocokkan dengan foto di e-KTP
            │
            ▼
4. Data wajah & KTP disimpan sebagai bukti verifikasi (auth)
   Akun berstatus "Terverifikasi"
            │
            ▼
   Otomatis masuk ke Dashboard
```

**Poin desain penting:**
- Deteksi dukungan NFC dilakukan **otomatis oleh sistem** (bukan pertanyaan ke user) — jika perangkat tidak mendukung, app langsung mengarahkan ke alur foto manual tanpa user perlu memilih
- Liveness Detection **wajib** di kedua jalur (NFC maupun foto manual) — ini yang mengikat identitas fisik user ke akunnya
- Hasil KYC (data wajah + KTP) menjadi metode autentikasi tambahan yang disimpan, dipakai sistem untuk memverifikasi keaslian akun, bukan untuk login sehari-hari
- Login rutin sehari-hari **tidak mengulang proses ini** — cukup NIK + Password

**Opsional (peningkatan UX):** setelah login pertama berhasil, app bisa menawarkan biometric login perangkat (sidik jari/Face ID bawaan HP) sebagai shortcut untuk login berikutnya. Ini berbeda dari Liveness Detection KYC — sifatnya hanya kenyamanan re-login, bukan verifikasi identitas ke pihak kampus.

**Eksekusi Suara** — momen paling kritis, selalu melalui urutan:
1. Review pilihan (kandidat/delegate yang dipilih)
2. Peringatan irreversibilitas
3. Slide-to-vote (konfirmasi fisik, bukan sekadar tap)
4. Animasi enkripsi (anonimisasi → enkripsi → kirim ke jaringan)
5. E-Receipt sebagai bukti sah tanpa membocorkan pilihan

---

## 4. Daftar Halaman & Fungsinya

### 4.1 Role: User (Pemilih Dasar)

| # | Halaman | Fungsi |
|---|---|---|
| 1 | **Splash & Onboarding** | Perkenalan app, carousel 3 slide menjelaskan konsep Liquid Democracy, kerahasiaan, dan delegasi |
| 2 | **Login** | Autentikasi rutin via **NIK + Password** saja — tanpa KYC ulang (hanya untuk akun yang sudah terverifikasi) |
| 3 | **Registrasi — Buat Akun** | Input NIK + buat password baru untuk akun |
| 4 | **Registrasi — Tap NFC e-KTP** | Ditampilkan otomatis jika perangkat mendukung NFC — baca chip e-KTP, data terisi otomatis |
| 5 | **Registrasi — Foto e-KTP** | Fallback otomatis jika perangkat **tidak** mendukung NFC — foto manual via kamera dengan frame guide, OCR, lalu review hasil |
| 6 | **Registrasi — Liveness Detection** | Wajib di kedua jalur (NFC maupun foto) — deteksi wajah real-time + kedip, dicocokkan dengan foto KTP, hasil disimpan sebagai bukti verifikasi (auth) |
| 7 | **Dashboard** | Ringkasan status: bobot suara, pemilihan aktif, notifikasi |
| 8 | **Election Hub** | Detail satu pemilihan — tab "Daftar Kandidat" dan tab "Delegasikan Suara" |
| 9 | **Profil & Track Record Kandidat** | Visi-misi, timeline rekam jejak, program kerja, tombol "Pilih Kandidat" |
| 10 | **Ruang Eksekusi & Kriptografi** | Review pilihan final, slide-to-vote, animasi enkripsi |
| 11 | **E-Receipt (Pilihan Langsung)** | Bukti sah pemilihan — hash transaksi, QR validasi, tanpa membocorkan pilihan |
| 12 | **Delegation Hub** | Daftar delegator terverifikasi, pencarian, filter berdasarkan keahlian |
| 13 | **Detail Delegator & Konfirmasi** | Profil lengkap calon delegate, track record, tombol konfirmasi delegasi |
| 14 | **E-Receipt (Delegasi)** | Bukti delegasi — termasuk nama delegate dan opsi pembatalan |
| 15 | **Profil User** | Data diri, riwayat partisipasi, pengaturan akun |
| 16 | **Edit Profil** | Ubah nama/kontak (NIK & fakultas terkunci, mengikuti data KTP terverifikasi) |
| 17 | **Ajukan Pemilihan — Step 1: Info Dasar** | Form nama pemilihan, jenis, tujuan, periode, estimasi pemilih |
| 18 | **Ajukan Pemilihan — Step 2: Daftar Kandidat** | Input nama + NIM calon kandidat yang diusulkan |
| 19 | **Ajukan Pemilihan — Step 3: Review & Submit** | Ringkasan usulan sebelum dikirim ke admin |
| 20 | **Status Usulan Saya** | Tracking status usulan: Diajukan → Direview → Disetujui/Ditolak |
| 21 | **Form Lengkapi Profil Kandidat** | Diterima oleh kandidat yang diusulkan — isi visi misi, track record, program kerja sendiri |

### 4.2 Role: Delegate (Tambahan dari User)

| # | Halaman | Fungsi |
|---|---|---|
| 21 | **Delegate Dashboard** | Statistik tambahan: total suara dipegang, trust score, alert eksekusi yang diperlukan |
| 22 | **Manajemen Mandat** | Daftar lengkap user yang mendelegasikan suara, status per mandator (aktif/dicabut) |
| 23 | **Eksekusi Suara (Delegate)** | Sama seperti eksekusi User biasa, dengan tambahan breakdown bobot suara gabungan sebelum slide-to-vote |
| 24 | **E-Receipt Delegate** | Bukti eksekusi dengan breakdown jumlah mandator dan total bobot — tetap tanpa membocorkan pilihan |
| 25 | **Profil Publik Delegate** | Halaman yang dilihat User lain — bio, visi delegasi, track record, statistik kepercayaan |
| 26 | **Riwayat Eksekusi** | Audit trail semua pemilihan yang pernah dieksekusi sebagai delegate |
| 27 | **Profil Delegate (Own View / Edit)** | Performa delegate (trust score, ketepatan eksekusi), pengaturan profil publik |

### 4.3 Role: Admin (Mobile — Monitoring & Aksi Cepat)

| # | Halaman | Fungsi |
|---|---|---|
| 28 | **Admin Dashboard (Mobile)** | Statistik real-time, grafik turnout per jam, status sistem, quick actions |
| 29 | **Daftar Pemilihan (Mobile)** | List pemilihan dengan status (Live/Terjadwal/Draft/Selesai) dan aksi cepat |
| 30 | **Inbox Usulan Pemilihan** | Review usulan masuk dari User/organisasi |
| 31 | **Detail Review Usulan** | Cek kelayakan usulan dan kandidat, approve/tolak |
| 32 | **Detail Tracking Usulan Admin** | Melacak progres usulan pemilihan dari diajukan, direview, disetujui/ditolak, hingga menjadi draft |
| 33 | **Detail Kandidat Usulan Admin** | Melihat daftar kandidat yang diajukan dalam sebuah usulan pemilihan, termasuk identitas ringkas dan status kelengkapan |
| 34 | **Verifikasi Kandidat** | Daftar kandidat yang sudah melengkapi profil dan menunggu verifikasi admin |
| 35 | **Lihat Berkas Kandidat** | Memeriksa dokumen kandidat seperti formulir pendaftaran, KTM, surat rekomendasi, dan visi-misi |
| 36 | **Tinjau Kandidat** | Checklist verifikasi kandidat dan pengambilan keputusan admin: setujui atau tolak |
| 37 | **Sengketa KYC** | Verifikasi manual untuk kasus KYC gagal, dengan catatan audit wajib |

### 4.4 Role: Admin (Web Dashboard — Setup & Deep Work)

> Belum didesain mendetail — direncanakan menggunakan stack web terpisah (mis. React/Next.js) yang terhubung ke Supabase yang sama.

| # | Halaman | Fungsi |
|---|---|---|
| 33 | **Manajemen Pemilihan (Web)** | CRUD pemilihan lengkap — form detail, pengaturan delegasi, jadwal |
| 34 | **Manajemen Kandidat (Web)** | Input data kandidat lengkap — timeline builder, program kerja card builder |
| 35 | **Manajemen Pemilih (Web)** | Import DPT (CSV/Excel), kelola status KYC massal |
| 36 | **Hasil & Pemantauan (Web)** | Live vote count, breakdown suara langsung vs delegasi, sertifikasi hasil, export laporan |
| 37 | **Audit Log & Keamanan (Web)** | Activity log immutable, deteksi anomali, status blockchain, manajemen akses admin |

---

## 5. Model Pengajuan Pemilihan (Hybrid: Usulan + Persetujuan)

Bukan murni top-down (admin only) maupun murni bottom-up (user bebas membuat sendiri). Alurnya:

```
1. User/Organisasi mengajukan usulan
   (nama pemilihan, tujuan, daftar nama+NIM calon kandidat)
            │
            ▼
2. Admin menerima usulan di Inbox Usulan Pemilihan
            │
            ├──► Lacak Detail Usulan
            │    Admin melihat progres usulan dari diajukan hingga keputusan akhir
            │
            └──► Lihat Detail Kandidat
                 Admin memeriksa daftar kandidat yang diajukan dalam usulan
            │
            ▼
3. Admin review kelayakan usulan
            │
            ▼
4. Admin approve → otomatis jadi draft pemilihan
   (admin tinggal lengkapi DPT, pengaturan delegasi, jadwal final)
            │
            ▼
5. Kandidat yang diusulkan menerima notifikasi
   untuk mengisi profil sendiri
   (visi misi, track record, program kerja, berkas pendukung)
            │
            ▼
6. Admin membuka halaman Verifikasi Kandidat
            │
            ├──► Lihat Berkas Kandidat
            │    Memeriksa dokumen dan kelengkapan pengajuan kandidat
            │
            └──► Tinjau Kandidat
                 Checklist verifikasi dan keputusan setujui/tolak
            │
            ▼
7. Kandidat lolos verifikasi → status "Siap Tayang"
            │
            ▼
8. Pemilihan otomatis menjadi Live pada waktu terjadwal
```

**Tombol admin yang menjadi bagian dari alur ini:**

| Tombol | Dari Halaman | Menuju Halaman |
|---|---|---|
| **Lacak Detail** | Inbox/monitor usulan admin | Detail Tracking Usulan Admin |
| **Lihat Detail Kandidat** | Inbox/monitor usulan admin | Detail Kandidat Usulan Admin |
| **Lihat Berkas** | Verifikasi Kandidat | Berkas Kandidat |
| **Tinjau Sekarang** | Verifikasi Kandidat | Tinjau Kandidat |

> Catatan implementasi:
> Halaman admin untuk tracking usulan, detail kandidat, lihat berkas, dan tinjau kandidat
> saat ini sudah tersedia pada sisi Flutter, namun data masih bersifat statis/dummy.
> Integrasi final dengan Supabase akan dilakukan pada tahap backend dan repository layer.

**Mengapa model ini dipilih:**
- Mengurangi beban admin secara drastis (tidak perlu mengetik ulang visi-misi tiap kandidat)
- Tetap ada gatekeeping untuk mencegah pemilihan spam/kandidat tidak layak
- Inisiatif demokratis bisa datang dari organisasi mahasiswa, bukan top-down semata
- Akuntabilitas data ada di tangan kandidat sendiri karena mereka yang mengisi profilnya

---

## 6. Prinsip Keamanan & Privasi (Berlaku di Semua Role)

1. **Tidak ada pilihan plaintext** — pilihan suara harus terenkripsi sebelum disimpan di mana pun, termasuk di database
2. **Admin tidak pernah bisa melihat pilihan individu** — hanya status partisipasi (sudah/belum memilih), bukan ke mana suaranya
3. **E-Receipt tidak membocorkan pilihan** — struk hanya berisi hash transaksi, waktu, dan status, untuk mencegah *vote buying* (pemilih dipaksa menunjukkan bukti pilihannya)
4. **Audit log bersifat immutable** — semua aksi admin tercatat dan tidak bisa diubah/dihapus
5. **NIK tidak disimpan dalam bentuk asli** — disimpan sebagai hash, bukan plaintext, untuk privasi data kependudukan
6. **KYC hanya sekali di Registrasi** — proses verifikasi identitas (NIK, NFC/foto KTP, liveness detection) tidak diulang setiap login; setelah akun berstatus "Terverifikasi", autentikasi rutin cukup NIK + Password

---

## 7. Arsitektur Teknis (Ringkas)

**Frontend Mobile:** Flutter, Clean Architecture (Presentation → Domain → Data), Feature-First folder structure

**State Management:** Riverpod

**Backend:** Supabase (PostgreSQL + Realtime + Auth + Storage, dengan Row Level Security)

**Database Lokal:** Drift (SQLite type-safe) — digunakan untuk caching, draft form, dan data non-kritis. Data yang menyangkut integritas suara **wajib** di server/blockchain, tidak boleh hanya lokal.

| Jenis Data | Lokasi Penyimpanan |
|---|---|
| Hasil suara terenkripsi | Cloud + Chain (wajib) |
| Status KYC & verifikasi | Cloud (wajib) |
| Audit log admin | Cloud (wajib, immutable) |
| Data kandidat (visi/misi/dll) | Hybrid — master di cloud, cache lokal |
| Cache dashboard/statistik | Hybrid — stale-while-revalidate |
| Draft form (usulan, profil kandidat) | Lokal (SQLite/Drift) |
| Sesi login & token auth | Lokal aman (flutter_secure_storage) |
| Preferensi UI (tema, bahasa) | Lokal (SharedPreferences) |

**Desain Visual:** Glassmorphism, tema terang, palet Navy Blue (`#0f1f3d`) × Matte Gold (`#D4A030`–`#9C7523`) × Frosted Silver. Tipografi: Plus Jakarta Sans (heading) + DM Sans (body).

---

## 8. Status Dokumen

- [x] Alur User — selesai didesain (UI/UX + prompt Stitch)
- [x] Alur Delegate — selesai didesain (UI/UX + prompt Stitch)
- [x] Alur Admin Mobile — selesai didesain dan sebagian sudah diimplementasikan di Flutter
- [x] Alur Pengajuan Pemilihan — selesai didesain (UI/UX + prompt Stitch)
- [x] Alur Review Usulan Admin — halaman tracking dan detail kandidat sudah dibuat
- [x] Alur Verifikasi Kandidat Admin — halaman daftar kandidat, lihat berkas, dan tinjau kandidat sudah dibuat
- [ ] Web Dashboard Admin — belum didesain detail
- [ ] Integrasi Supabase — tahap setup arsitektur
- [ ] Implementasi enkripsi suara (mekanisme kriptografi spesifik) — belum ditentukan

---

*Dokumen ini hidup (living document) — perbarui setiap kali ada perubahan signifikan pada alur, role, atau halaman aplikasi.*
