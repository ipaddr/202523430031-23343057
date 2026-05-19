# Auklus

AI-powered legal contract risk analyzer untuk platform Android. Upload dokumen kontrak (PDF atau foto), dan Auklus akan menganalisis setiap klausul untuk mengidentifikasi potensi risiko.

## Fitur

- **OCR & PDF Parsing** — Ekstrak teks dari foto dokumen atau file PDF
- **AI Text Cleaning** — Gemini AI membersihkan dan menormalisasi hasil OCR
- **Risk Classification** — ML backend mengklasifikasi setiap klausul ke level risiko (Rendah / Sedang / Tinggi)
- **Risk Score** — Skor keseluruhan 0–100 dengan label AMAN / PERLU PERHATIAN / BAHAYA
- **Highlighted Document** — Dokumen lengkap dengan warna highlight per klausul
- **Scan History** — Riwayat semua scan tersimpan di cloud (Firestore)
- **Search & Filter** — Cari dokumen dan filter berdasarkan level risiko

## Tech Stack

| Layer            | Teknologi                      |
| ---------------- | ------------------------------ |
| Framework        | Flutter (Dart)                 |
| State Management | Provider (ChangeNotifier)      |
| Authentication   | Firebase Auth (Email/Password) |
| Database         | Cloud Firestore                |
| OCR              | Google ML Kit Text Recognition |
| PDF              | Syncfusion Flutter PDF         |
| AI Cleaning      | Google Gemini API              |
| ML Backend       | Custom HuggingFace Space       |

## Struktur Proyek

```
lib/
├── main.dart                  # Entry point, Firebase init, MultiProvider
├── theme.dart                 # Design system (warna, tipografi, tema)
├── firebase_options.dart      # Firebase config (auto-generated)
├── providers/
│   ├── auth_provider.dart     # Login, register, logout, profile update
│   ├── document_provider.dart # Upload file, OCR, Gemini cleaning
│   ├── analysis_provider.dart # ML API call, risk scoring, highlight
│   └── history_provider.dart  # Firestore CRUD, search, filter
├── screens/
│   ├── login_screen.dart      # Login & register dengan animasi slide
│   ├── main_screen.dart       # Bottom navigation (Scan, Riwayat, Profil)
│   ├── scan_screen.dart       # Upload zone + recent scans
│   ├── extracted_text_screen.dart # Preview teks hasil ekstraksi
│   ├── analyzing_screen.dart  # Loading animation saat analisis ML
│   ├── result_screen.dart     # Hasil analisis lengkap
│   ├── history_screen.dart    # Riwayat scan dengan search & filter
│   └── profile_screen.dart    # Profil pengguna & edit akun
└── services/
    ├── auth_service.dart      # Firebase Auth + Firestore user ops
    ├── gemini_service.dart    # Gemini API integration
    └── ml_service.dart        # ML backend API integration
```

## Setup

### Prasyarat

- Flutter SDK >= 3.11.0
- Android Studio / VS Code
- Firebase project yang sudah dikonfigurasi
- Gemini API key

### Instalasi

```bash
# Clone repository
git clone https://github.com/username/auklus.git
cd auklus

# Buat file .env dari template
cp .env.example .env
# Edit .env dan isi GEMINI_API_KEY

# Install dependencies
flutter pub get

# Jalankan aplikasi
flutter run
```

### Environment Variables

Buat file `.env` di root proyek:

```
GEMINI_API_KEY=api_gemini_anda_di_sini
```

Dapatkan Gemini API key dari [Google AI Studio](https://aistudio.google.com/apikey).

## Klasifikasi Risiko

| Label                | Arti                 | Level      |
| -------------------- | -------------------- | ---------- |
| `clearly_fair`       | Klausul adil         | Rendah (0) |
| `potentially_unfair` | Berpotensi merugikan | Sedang (1) |
| `clearly_unfair`     | Jelas merugikan      | Tinggi (2) |

### Formula Skor

```
score = (total bobot klausul) / (jumlah klausul × 2) × 100

Bobot: clearly_fair = 2, potentially_unfair = 1, clearly_unfair = 0

≥ 70 → AMAN
≥ 40 → PERLU PERHATIAN
< 40 → BAHAYA
```

## Screenshot

.

## Tentang

- **Nama** : Muhammad Ghazian Tsaqif Zhafiri Andoz
- **NIM** : 23343057
- **Program Studi** : Informatika (S1)

Proyek ini dibuat untuk keperluan akademik mata kuliah Mobile Programming Lanjutan yang diampu oleh Iip Permana, S.T., M.T.
