# Tugas Minggu 5: Motifa - Klasifikasi Motif Batik

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

---

## 🖼️ Screenshot


### Proses training model:

<img alt="Screenshot 2026-03-18 015239" src="https://github.com/user-attachments/assets/9bfd62da-9172-4a81-ba30-dadcfd228420" />

### Screenshot in-app:

- Icon dan Nama Aplikasi
<img src="https://github.com/user-attachments/assets/f3058d32-dfc2-4708-9756-9a4c16c42b5b" width="250"/>

- Tampilan Utama
<p align="left">
  <img src="https://github.com/user-attachments/assets/73f9f8ea-923d-44df-94d4-8cd0994fae52" width="250"/>
  <img src="https://github.com/user-attachments/assets/fb64d067-231f-472c-b2ae-a967dd75f19e" width="250"/>
  <img src="https://github.com/user-attachments/assets/a46bd396-bad5-4e6b-877e-f3b8381620b8" width="250"/>
</p>

<p align="left">
  <img src="https://github.com/user-attachments/assets/69948a84-0b85-489b-bcad-bb5323947f22" width="250"/>
  <img src="https://github.com/user-attachments/assets/421ae6b2-e8ca-4b95-b862-e40ad77f3de3" width="250"/>
  <img src="https://github.com/user-attachments/assets/fba19061-48b3-416c-bd36-d30a60f407c9" width="250"/>
</p>

- Proses Identifikasi Gambar (Pick dari File/Galeri)
<p align="left">
  <img src="https://github.com/user-attachments/assets/a46bd396-bad5-4e6b-877e-f3b8381620b8" width="250"/>
  <img src="https://github.com/user-attachments/assets/9c72e203-0788-4fd4-98de-d0b3433d9e7d" width="250"/>
  <img src="https://github.com/user-attachments/assets/36cf6d7e-ce5d-44a6-b8b6-9cc0b7b3a978" width="250"/>
</p>

<p align="left">
  <img src="https://github.com/user-attachments/assets/03ce782d-8fbd-4065-abd0-241032ce67bf" width="250"/>
  <img src="https://github.com/user-attachments/assets/4f02190f-f2c5-48b3-9743-c5c8199ca3e7" width="250"/>
  <img src="https://github.com/user-attachments/assets/0d790580-656e-433c-8a02-08329b4615d7" width="250"/>
</p>

<p align="left">
  <img src="https://github.com/user-attachments/assets/72bd0e34-df66-41a8-b8b2-9bbd075a14f4" width="250"/>
  <img src="https://github.com/user-attachments/assets/b136f3e5-3276-4736-9e34-eedf47cdef5d" width="250"/>
</p>

- Proses Identifikasi Gambar (Pick dari Kamera)
<p align="left">
  <img src="https://github.com/user-attachments/assets/b4eb5243-e639-4ae4-8e61-c938fe8c39c9" width="250"/>
  <img src="https://github.com/user-attachments/assets/01c0c04a-c9b8-43df-8ec6-0ed405e8b56a" width="250"/>
  <img src="https://github.com/user-attachments/assets/b53625d8-6c2b-4549-b40d-6afe67089cee" width="250"/>
</p>

- Hapus Riwayat
<img src="https://github.com/user-attachments/assets/8bd3b685-94fc-4618-a8e4-7d45ac5f633b" width="250"/>
