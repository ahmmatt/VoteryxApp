# Laporan Analisis UX & Alur Voteryx

Berdasarkan tinjauan terhadap `VOTERYX_APP_FLOW.md` dan struktur UI/UX yang telah dibangun, berikut adalah temuan mengenai potensi kesalahan alur (logic flaws) dan ketidaknyamanan pengguna (friction points):

## 1. Kesalahan Logika Alur (Flow Logic Flaws)

### A. Role "Delegate" vs "User" yang Terpisah
**Masalah:** Dokumen menyebutkan bahwa Delegate adalah *status tambahan* bagi User saat menerima mandat. Namun, saat ini terdapat halaman login terpisah (`DelegateLoginScreen`) dan dashboard yang sepenuhnya terpisah. 
**Dampak:** User yang kebetulan menjadi Delegate akan merasa memiliki "dua akun". Jika mereka ingin memilih secara langsung di pemilihan A, dan mewakili mandat di pemilihan B, mereka harus *logout* dan *login* bolak-balik antara portal User dan Delegate. Ini sangat tidak nyaman.
**Solusi:** Sebaiknya tidak ada "Portal Delegate" terpisah. Cukup gunakan satu aplikasi utama, di mana navigasi atau *Dashboard* beradaptasi (menambahkan menu "Mode Delegate") jika status akun tersebut adalah delegate yang aktif.

### B. Fallback NFC yang Terlalu Kaku
**Masalah:** Deteksi NFC otomatis dan langsung diarahkan ke foto manual jika tidak ada NFC. 
**Dampak:** Bagaimana jika HP pengguna mendukung NFC, tetapi chip e-KTP mereka rusak (sering terjadi)? Sistem akan terus memaksa mereka melakukan tap NFC tanpa jalan keluar.
**Solusi:** Harus ada tombol "Lewati & Gunakan Foto Manual" di layar scan NFC sebagai opsi darurat (*escape hatch*).

### C. Pencegahan Rantai Delegasi (Delegation Loop)
**Masalah:** Aturan menyebutkan Delegate tidak bisa mendelegasikan ulang suaranya. 
**Dampak:** Jika UI tidak secara proaktif menyembunyikan atau mendisable tombol "Delegasikan Suara" bagi mereka yang berstatus Delegate, pengguna akan mencoba menekan tombol tersebut dan baru mendapatkan error di akhir proses.
**Solusi:** Tombol "Delegasikan Suara" harus berubah menjadi status *disabled* dengan tooltip "Anda sedang memegang mandat, tidak dapat mendelegasikan suara."

## 2. Analisis Visual & UI (UI/UX Friction)

### A. Konteks Visual yang "Mirip-Mirip"
**Masalah:** Seperti yang Anda amati, banyak halaman yang terlihat serupa meskipun konteksnya berbeda (Admin, User, Delegate). Saat ini, aplikasi terlalu bergantung pada palet warna Navy dan Emas (`AppColors.primary900` dan `AppColors.goldMid`) untuk semua *role*.
**Dampak:** Pengguna bisa bingung apakah mereka sedang berada di layar Dashboard User biasa atau sedang berada di layar eksekusi mandat (Delegate).
**Solusi:** Gunakan aksen warna yang spesifik untuk setiap mode:
- **User Mode:** Navy Blue & Gold (Mewah & Standar).
- **Delegate Mode:** Teal atau Emerald Green (Melambangkan kepercayaan/trust dan tindakan).
- **Admin Mode:** Deep Red atau Slate Grey (Melambangkan otoritas dan pengaturan).

### B. Proses Voting yang Terlalu Panjang
**Masalah:** Langkah *Review -> Peringatan -> Slide-to-vote -> Animasi -> Receipt* sangat bagus untuk keamanan Pemilihan Presiden BEM. Namun, jika ada 5 pemilihan kecil (misal: himpunan, ketua angkatan, dsb), alur ini akan terasa sangat melelahkan.
**Dampak:** Tingkat *drop-off* (user yang tidak menyelesaikan voting) bisa meningkat pada pemilihan berskala kecil.
**Solusi:** Sediakan mode *Fast-track* (tanpa animasi panjang) untuk pemilihan dengan tingkat kepentingan rendah, namun tetap pertahankan *Slide-to-vote* untuk mencegah ketidaksengajaan.

### C. Bottom Navigation yang Membengkak
**Masalah:** Pada desain sebelumnya, setiap halaman memiliki kode *Bottom Navigation Bar*-nya sendiri. Jika ada perubahan satu menu, kita harus merubah di puluhan file.
**Dampak:** Rentan terjadi bug navigasi (misalnya tab aktif yang salah).
**Solusi:** (*Telah Diselesaikan*) Pembaruan terbaru telah memindahkan navigasi ke dalam template `StatefulShellRoute`, sehingga UI *navbar* menjadi konsisten, persisten (tidak ter-reload), dan terpusat.
