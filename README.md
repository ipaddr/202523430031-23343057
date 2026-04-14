# AbsenKu

**AbsenKu** adalah aplikasi presensi yang dirancang khusus untuk mempermudah dosen merekap kehadiran mahasiswa dari salinan pesan teks grup (seperti WhatsApp).

## Proses Automasi (RPA)

Berdasarkan cara kerjanya, letak automasinya ada pada bagian **Ekstraksi & Pencocokan Karakter (Data Cleansing & Matching)**:
- **Pembersihan Format Teks Automatis**: Sistem menggunakan regular expression (_Regex_) untuk otomatis membuang angka, titik, dan karakter tak penting dari *paste* mahasiswa. Dosen tidak perlu menghapus angkanya satu per satu secara manual.
- **Pencocokan Cerdas**: Proses menghitung atau mencari nama di buku absen konvensional sangat memakan waktu. Automasi pada aplikasi bekerja dengan algoritma perbandingan senar secara langsung iteratif pada riwayat pencatatan kemudian mencatat dan mengkategorikan secara otomatis.

## Cara Kerja

1. **Daftarkan Mahasiswa**: Buka tab _Mahasiswa_ dan daftarkan mahasiswa baru dengan menekan tombol `+` (masukkan Nama Lengkap dan NIM).

<p align="left">
  <img src="https://github.com/user-attachments/assets/0a28135e-2daa-4662-bde6-07f5670fbf09" width="250">
  <img src="https://github.com/user-attachments/assets/3f5be7ef-1f28-4748-8695-267e98308278" width="250">
  <img src="https://github.com/user-attachments/assets/33948aa4-8f24-4d6f-9f77-18642ad1659f" width="250">
</p>

2. **Kumpulkan Data Chat**: Biarkan mahasiswa melakukan list daftar hadir di grup obrolan (misalnya: "1. Randi \n 2. Budi", dsb).

<img src="https://github.com/user-attachments/assets/e38c9482-178e-45fb-9881-5ff9dc148542" width="250">

3. **Rekap Otomatis**: Dosen hanya perlu menyalin (copy) daftar peserta dari chat terakhir, lalu menempelkannya (paste) pada kotak di tab _Rekap_.

<p align="left">
  <img src="https://github.com/user-attachments/assets/dbd5a492-2243-432e-acb2-b69cd2552dd5" width="250">
  <img src="https://github.com/user-attachments/assets/ff1c3c2d-6465-41f2-8007-61034e00e343" width="250">
</p>

4. **Pencatatan Kehadiran**: Saat tombol **PROSES ABSENSI** ditekan, aplikasi akan secara otomatis membersihkan urutan nomor dan merekap jumlah kehadiran yang berhasil ditambahkan sesuai dengan kecocokan nama pada database mahasiswa lokal!

<img src="https://github.com/user-attachments/assets/ccff5025-8655-4333-be0b-9f25c8419fda" width="250">
