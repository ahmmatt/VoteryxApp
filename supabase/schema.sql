-- ====================================================================
-- SCHEMA DATABASE VOTERYX (POSTGRESQL - SUPABASE)
-- Ditata ulang agar 100% sinkron dengan model dan repository Flutter
-- ====================================================================

-- Drop tabel lama jika ada agar sinkronisasi bersih (untuk dev/reset)
DROP TABLE IF EXISTS public.user_notifications CASCADE;
DROP TABLE IF EXISTS public.proposal_candidates CASCADE;
DROP TABLE IF EXISTS public.delegates CASCADE;
DROP TABLE IF EXISTS public.delegations CASCADE;
DROP TABLE IF EXISTS public.votes CASCADE;
DROP TABLE IF EXISTS public.candidates CASCADE;
DROP TABLE IF EXISTS public.elections CASCADE;
DROP TABLE IF EXISTS public.election_proposals CASCADE;
DROP TABLE IF EXISTS public.users CASCADE;

-- 1. Tabel Profil Pengguna (melengkapi auth.users)
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    nik_hash TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    faculty TEXT,
    major TEXT,
    nim TEXT,
    birth_place TEXT,
    birth_date TEXT,
    gender TEXT,
    address TEXT,
    phone TEXT,
    email TEXT,
    avatar_url TEXT,
    role TEXT DEFAULT 'voter', -- 'voter', 'delegate', 'admin'
    kyc_status TEXT DEFAULT 'unverified', -- 'unverified', 'pending', 'verified', 'rejected'
    vote_weight INTEGER DEFAULT 1,
    is_delegate_profile_public BOOLEAN DEFAULT false,
    delegate_bio TEXT,
    delegate_vision TEXT,
    delegate_skills JSONB DEFAULT '[]'::jsonb,
    delegate_track_records JSONB DEFAULT '[]'::jsonb,
    trust_score DOUBLE PRECISION DEFAULT 0.0,
    delegated_to UUID REFERENCES public.users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- Pastikan kolom KTP & profil ditambahkan jika tabel users sudah ada sebelumnya di Supabase
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS nim TEXT;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS phone TEXT;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS major TEXT;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS is_delegate_profile_public BOOLEAN DEFAULT false;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS delegate_bio TEXT;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS delegate_vision TEXT;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS delegate_skills JSONB DEFAULT '[]'::jsonb;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS delegate_track_records JSONB DEFAULT '[]'::jsonb;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS birth_place TEXT;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS birth_date TEXT;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS gender TEXT;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS address TEXT;

-- 2. Tabel Pemilihan (Elections)
CREATE TABLE IF NOT EXISTS public.elections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    status TEXT DEFAULT 'draft', -- 'live', 'scheduled', 'completed', 'draft'
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE NOT NULL,
    description TEXT,
    organization TEXT,
    election_type TEXT, -- 'Universitas', 'Fakultas', 'Himpunan', 'BEM'
    banner_url TEXT,
    estimated_voters INTEGER DEFAULT 0,
    public_key TEXT,
    dpt_config JSONB DEFAULT '{"faculty": "all", "major": "all", "specific_users": []}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Tabel Kandidat (Candidates)
CREATE TABLE IF NOT EXISTS public.candidates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    election_id UUID REFERENCES public.elections(id) ON DELETE CASCADE NOT NULL,
    full_name TEXT NOT NULL,
    nim TEXT,
    faculty TEXT,
    major TEXT,
    photo_url TEXT,
    form_url TEXT,
    form_text TEXT,
    ktm_url TEXT,
    ktm_text TEXT,
    vision_mission_url TEXT,
    recommendation_url TEXT,
    recommendation_text TEXT,
    documents JSONB DEFAULT '[]'::jsonb,
    visi TEXT,
    misi TEXT,
    track_records JSONB DEFAULT '[]'::jsonb,
    programs JSONB DEFAULT '[]'::jsonb,
    vote_count INTEGER DEFAULT 0,
    is_verified BOOLEAN DEFAULT true,
    candidate_number INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Tabel Suara / Voting (Votes)
CREATE TABLE IF NOT EXISTS public.votes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    election_id UUID REFERENCES public.elections(id) ON DELETE CASCADE NOT NULL,
    voter_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    candidate_id UUID REFERENCES public.candidates(id) ON DELETE CASCADE,
    vote_weight INTEGER DEFAULT 1,
    encrypted_choice TEXT NOT NULL,
    transaction_hash TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT unique_voter_per_election UNIQUE (election_id, voter_id) -- Mencegah double voting!
);

-- 5. Tabel Delegasi Suara (Delegations - Liquid Democracy)
CREATE TABLE IF NOT EXISTS public.delegations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    election_id UUID REFERENCES public.elections(id) ON DELETE CASCADE NOT NULL,
    delegator_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    delegate_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    status TEXT DEFAULT 'active', -- 'active', 'revoked'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 6. Tabel Pengajuan Delegasi (Delegate Applications)
CREATE TABLE IF NOT EXISTS public.delegate_applications (
    id TEXT PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    expertise TEXT,
    bio TEXT,
    track_record TEXT,
    portfolio_url TEXT,
    is_student BOOLEAN DEFAULT true,
    nim TEXT,
    status TEXT DEFAULT 'pending', -- 'pending', 'approved', 'rejected'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 7. Tabel Usulan Pemilihan (Election Proposals)
CREATE TABLE IF NOT EXISTS public.election_proposals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proposer_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    election_type TEXT DEFAULT 'BEM',
    organization TEXT,
    purpose TEXT,
    proposed_start_date TIMESTAMP WITH TIME ZONE,
    proposed_end_date TIMESTAMP WITH TIME ZONE,
    estimated_voters INTEGER DEFAULT 0,
    status TEXT DEFAULT 'pending', -- 'pending', 'under_review', 'approved', 'rejected'
    admin_note TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 6. Tabel Pengajuan Delegasi (Delegate Applications)
CREATE TABLE IF NOT EXISTS public.delegate_applications (
    id TEXT PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    expertise TEXT NOT NULL,
    bio TEXT NOT NULL,
    track_record TEXT NOT NULL,
    portfolio_url TEXT,
    is_student BOOLEAN DEFAULT false,
    nim TEXT,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 8. Tabel Kandidat per Proposal (Proposal Candidates)
CREATE TABLE IF NOT EXISTS public.proposal_candidates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proposal_id UUID REFERENCES public.election_proposals(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    full_name TEXT NOT NULL,
    nik_or_nim TEXT,              -- NIK atau NIM yang dicari saat pengajuan
    docs_completed BOOLEAN DEFAULT false,  -- true setelah kandidat lengkapi berkas
    notification_sent BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 9. Tabel Notifikasi Persisten per User
CREATE TABLE IF NOT EXISTS public.user_notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT NOT NULL,           -- 'candidate_nominated', 'proposal_approved', 'proposal_rejected', 'proposal_pending'
    is_read BOOLEAN DEFAULT false,
    is_dismissed BOOLEAN DEFAULT false,  -- notif kandidat hanya bisa dismiss setelah docs_completed=true
    reference_id TEXT,            -- proposal_id atau election_id terkait
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Tambahkan kolom baru yang mungkin belum ada di Supabase yang sudah running
ALTER TABLE public.election_proposals ADD COLUMN IF NOT EXISTS admin_note TEXT;
ALTER TABLE public.proposal_candidates ADD COLUMN IF NOT EXISTS docs_completed BOOLEAN DEFAULT false;
ALTER TABLE public.proposal_candidates ADD COLUMN IF NOT EXISTS notification_sent BOOLEAN DEFAULT false;
ALTER TABLE public.proposal_candidates ADD COLUMN IF NOT EXISTS is_verified BOOLEAN DEFAULT false;
ALTER TABLE public.proposal_candidates ADD COLUMN IF NOT EXISTS visi TEXT;
ALTER TABLE public.proposal_candidates ADD COLUMN IF NOT EXISTS misi TEXT;
ALTER TABLE public.proposal_candidates ADD COLUMN IF NOT EXISTS track_records JSONB DEFAULT '[]'::jsonb;
ALTER TABLE public.proposal_candidates ADD COLUMN IF NOT EXISTS programs JSONB DEFAULT '[]'::jsonb;
ALTER TABLE public.proposal_candidates ADD COLUMN IF NOT EXISTS photo_url TEXT;

-- ====================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ====================================================================

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.elections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.candidates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.delegations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.delegate_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.election_proposals ENABLE ROW LEVEL SECURITY;

-- Policy untuk pengembangan cepat (Izinkan read/write tanpa hambatan selama dev)
CREATE POLICY "Allow public read users" ON public.users FOR SELECT USING (true);
CREATE POLICY "Allow auth insert users" ON public.users FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow auth update own profile" ON public.users FOR UPDATE USING (true);

CREATE POLICY "Allow public read elections" ON public.elections FOR SELECT USING (true);
CREATE POLICY "Allow public read candidates" ON public.candidates FOR SELECT USING (true);

CREATE POLICY "Allow public read delegations" ON public.delegations FOR SELECT USING (true);
CREATE POLICY "Allow auth insert delegations" ON public.delegations FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow auth update delegations" ON public.delegations FOR UPDATE USING (true);

CREATE POLICY "Allow public read delegate_applications" ON public.delegate_applications FOR SELECT USING (true);
CREATE POLICY "Allow auth insert delegate_applications" ON public.delegate_applications FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow auth update delegate_applications" ON public.delegate_applications FOR UPDATE USING (true);

CREATE POLICY "Allow public read votes" ON public.votes FOR SELECT USING (true);
CREATE POLICY "Allow auth insert votes" ON public.votes FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow public read proposals" ON public.election_proposals FOR SELECT USING (true);
CREATE POLICY "Allow auth insert proposals" ON public.election_proposals FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow auth update proposals" ON public.election_proposals FOR UPDATE USING (true);

ALTER TABLE public.proposal_candidates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public read proposal_candidates" ON public.proposal_candidates FOR SELECT USING (true);
CREATE POLICY "Allow auth insert proposal_candidates" ON public.proposal_candidates FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow auth update proposal_candidates" ON public.proposal_candidates FOR UPDATE USING (true);

ALTER TABLE public.user_notifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow user read own notifications" ON public.user_notifications FOR SELECT USING (true);
CREATE POLICY "Allow auth insert notifications" ON public.user_notifications FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow auth update notifications" ON public.user_notifications FOR UPDATE USING (true);

-- ====================================================================
-- DUMMY SEED DATA (AGAR APLIKASI LANGSUNG HIDUP DAN MENARIK)
-- ====================================================================

-- Insert Dummy Election
INSERT INTO public.elections (id, title, status, start_date, end_date, description, organization, election_type, estimated_voters)
VALUES 
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Pemilihan Ketua BEM Universitas 2024', 'live', now() - interval '1 day', now() + interval '3 days', 'Pemilihan umum raya untuk menentukan Ketua dan Wakil Ketua Badan Eksekutif Mahasiswa tingkat Universitas periode 2024/2025.', 'Universitas Indonesia', 'Universitas', 15000),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'Pemilihan Ketua Himpunan Teknik Informatika', 'scheduled', now() + interval '1 day', now() + interval '5 days', 'Pemilihan Ketua Himpunan Mahasiswa Teknik Informatika (HMIF) untuk memimpin aspirasi dan inovasi mahasiswa komputer.', 'Fakultas Teknik', 'Himpunan', 1200)
ON CONFLICT DO NOTHING;

-- Insert Dummy Candidates untuk BEM Universitas
INSERT INTO public.candidates (
    election_id, full_name, candidate_number, faculty, major, photo_url,
    form_url, form_text, ktm_url, ktm_text, vision_mission_url, recommendation_url, recommendation_text, documents,
    visi, misi, programs, track_records, vote_count
)
VALUES 
(
  'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 
  'Rizky Pratama & Dinda Kirana', 
  1, 
  'Fakultas Teknik', 
  'Teknik Informatika',
  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=400&auto=format&fit=crop',
  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  'Formulir Pendaftaran Resmi Paslon Nomor Urut 1 (Rizky Pratama & Dinda Kirana).\n\nStatus: Terverifikasi oleh Komisi Pemilihan Umum Mahasiswa (KPUM).\nTanggal Daftar: 12 Oktober 2024.\nCatatan: Berkas lengkap dan memenuhi seluruh persyaratan administrasi.',
  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  'Kartu Tanda Mahasiswa (KTM) dan Kartu Hasil Studi (KHS) atas nama Rizky Pratama (NIM: 2106001001) dan Dinda Kirana (NIM: 2106001002).\n\nStatus Mahasiswa: Aktif Semester Ganjil 2024/2025.\nIPK Kumulatif: 3.85 / 3.90.',
  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  'Surat Rekomendasi Resmi Dekanat Fakultas Teknik dan Badan Perwakilan Mahasiswa (BPM) untuk pencalonan Rizky Pratama & Dinda Kirana dalam Pemilihan Ketua BEM Universitas 2024.',
  '[
    {"title": "Formulir Pendaftaran Resmi Paslon", "meta": "PDF • Berkas Terverifikasi Sistem", "content": "Form Pendaftaran Resmi Paslon Nomor Urut 1 (Rizky Pratama & Dinda Kirana).\\n\\nStatus: Terverifikasi oleh Komisi Pemilihan Umum Mahasiswa (KPUM).\\nTanggal Daftar: 12 Oktober 2024.", "file_url": "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"},
    {"title": "Kartu Tanda Mahasiswa (KTM) & KHS", "meta": "JPG / PDF • Status Mahasiswa Aktif", "content": "Kartu Tanda Mahasiswa (KTM) dan Kartu Hasil Studi (KHS) atas nama Rizky Pratama (NIM: 2106001001) dan Dinda Kirana (NIM: 2106001002).\\n\\nStatus Mahasiswa: Aktif Semester Ganjil 2024/2025.\\nIPK Kumulatif: 3.85 / 3.90.", "file_url": "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"},
    {"title": "Naskah Visi, Misi & Rencana Kerja (2 Program)", "meta": "PDF • 840 KB", "content": "Visi: Mewujudkan BEM Universitas yang Inklusif, Transparan, dan Berdaya Saing Global berbasis Teknologi Digital.\\n\\nMisi: Meningkatkan transparansi anggaran kemahasiswaan serta membangun ekosistem riset kolaboratif.", "file_url": "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"},
    {"title": "Surat Rekomendasi Organisasi & Fakultas", "meta": "PDF • 1.1 MB", "content": "Surat Rekomendasi Resmi Dekanat Fakultas Teknik dan Badan Perwakilan Mahasiswa (BPM) untuk pencalonan Rizky Pratama & Dinda Kirana dalam Pemilihan Ketua BEM Universitas 2024.", "file_url": "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"}
  ]'::jsonb,
  'Mewujudkan BEM Universitas yang Inklusif, Transparan, dan Berdaya Saing Global berbasis Teknologi Digital.', 
  'Meningkatkan transparansi anggaran kemahasiswaan serta membangun ekosistem riset kolaboratif.', 
  '[{"title": "Voteryx Fest & Tech Summit", "desc": "Festival teknologi dan inovasi mahasiswa bulanan."}, {"title": "Beasiswa Darurat", "desc": "Bantuan dana darurat untuk mahasiswa berprestasi."}]'::jsonb,
  '[{"year": "2023", "role": "Ketua Himpunan HMIF"}, {"year": "2022", "role": "Ketua Pelaksana TechFest"}]'::jsonb,
  2100
),
(
  'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 
  'Ahmad Fauzi & Siti Aisyah', 
  2, 
  'Fakultas Hukum', 
  'Ilmu Hukum',
  NULL,
  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  'Formulir Pendaftaran Resmi Paslon Nomor Urut 2 (Ahmad Fauzi & Siti Aisyah).\n\nStatus: Terverifikasi oleh Komisi Pemilihan Umum Mahasiswa (KPUM).\nTanggal Daftar: 13 Oktober 2024.\nCatatan: Berkas lengkap dan valid.',
  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  'Kartu Tanda Mahasiswa (KTM) dan KHS atas nama Ahmad Fauzi (NIM: 2104002001) dan Siti Aisyah (NIM: 2104002002).\n\nStatus Mahasiswa: Aktif Semester Ganjil 2024/2025.\nIPK Kumulatif: 3.78 / 3.82.',
  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  'Surat Rekomendasi Dekanat Fakultas Hukum dan Dewan Perwakilan Mahasiswa (DPM) untuk Paslon Ahmad Fauzi & Siti Aisyah.',
  '[
    {"title": "Formulir Pendaftaran Resmi Paslon", "meta": "PDF • Berkas Terverifikasi Sistem", "content": "Formulir Pendaftaran Resmi Paslon Nomor Urut 2 (Ahmad Fauzi & Siti Aisyah).\\n\\nStatus: Terverifikasi oleh Komisi Pemilihan Umum Mahasiswa (KPUM).\\nTanggal Daftar: 13 Oktober 2024.", "file_url": "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"},
    {"title": "Kartu Tanda Mahasiswa (KTM) & KHS", "meta": "JPG / PDF • Status Mahasiswa Aktif", "content": "Kartu Tanda Mahasiswa (KTM) dan KHS atas nama Ahmad Fauzi (NIM: 2104002001) dan Siti Aisyah (NIM: 2104002002).\\n\\nStatus Mahasiswa: Aktif Semester Ganjil 2024/2025.\\nIPK Kumulatif: 3.78 / 3.82.", "file_url": "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"},
    {"title": "Naskah Visi, Misi & Rencana Kerja (2 Program)", "meta": "PDF • 840 KB", "content": "Visi: BEM Universitas sebagai Rumah Bersama yang Kolaboratif, Aspiratif, dan Mengedepankan Integritas Akademik.\\n\\nMisi: Menguatkan solidaritas antar himpunan dan pengembangan karir berskala nasional.", "file_url": "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"},
    {"title": "Surat Rekomendasi Organisasi & Fakultas", "meta": "PDF • 1.1 MB", "content": "Surat Rekomendasi Dekanat Fakultas Hukum dan Dewan Perwakilan Mahasiswa (DPM) untuk Paslon Ahmad Fauzi & Siti Aisyah.", "file_url": "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"}
  ]'::jsonb,
  'BEM Universitas sebagai Rumah Bersama yang Kolaboratif, Aspiratif, dan Mengedepankan Integritas Akademik.', 
  'Menguatkan solidaritas antar himpunan dan pengembangan karir berskala nasional.', 
  '[{"title": "Career Expo & Mentoring Network", "desc": "Jaringan bimbingan karir langsung dari praktisi industri."}, {"title": "Pusat Layanan Mental Health", "desc": "Konseling gratis dan rahasia bagi seluruh mahasiswa."}]'::jsonb,
  '[{"year": "2023", "role": "Wakil Ketua BEM Fakultas Hukum"}, {"year": "2022", "role": "Ketua Departemen Advokasi"}]'::jsonb,
  2150
)
ON CONFLICT DO NOTHING;
