# Motifa - Klasifikasi Motif Batik

Motifa adalah aplikasi mobile berbasis Flutter yang dirancang untuk mengenali berbagai jenis motif batik menggunakan Machine Learning (TensorFlow Lite). Aplikasi ini mengintegrasikan layanan Firebase untuk manajemen pengguna dan penyimpanan data riwayat scan secara real-time.

---

## 🤖 Model & Assets

Aplikasi ini menggunakan Machine Learning On-Device untuk performa yang cepat dan privasi yang terjaga.

- **`assets/batik_model.tflite`**: Model TensorFlow Lite yang sudah dilatih khusus untuk mengenali berbagai motif batik Indonesia.
- **`assets/labels.txt`**: Daftar label/nama motif yang sesuai dengan urutan output dari model ML.
- **`lib/tensorflow.dart`**: Kelas utilitas yang menangani pemuatan model ke memori, prapemrosesan gambar (resize & normalisasi), dan penafsiran hasil (inference).

---

## 📂 Struktur Proyek

```text
lib/
├── services/
│   ├── auth/
│   │   └── bloc/           # Logika BLoC (State, Event, Bloc)
│   ├── auth_service.dart   # Firebase Auth Wrapper
│   └── firestore_service.dart # CRUD Firestore
├── views/
│   ├── login_view.dart     # UI Masuk
│   ├── register_view.dart  # UI Daftar
│   ├── main_view.dart      # Bottom Navigation Wrapper
│   ├── scan_view.dart      # Fitur Utama (ML)
│   ├── history_view.dart   # Daftar Riwayat
│   └── profile_view.dart   # Profil & Statistik
├── utilities/
│   └── dialogs/            # Dialog Konfirmasi (Hapus/Keluar)
├── tensorflow.dart         # Logika Load & Process TFLite
├── themes.dart             # Konfigurasi Tema (Brutalist)
└── main.dart               # Entry Point & Router
```
