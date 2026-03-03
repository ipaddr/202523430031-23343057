# Tugas Minggu 3

## Ringkasan Materi & Implementasi

Pada minggu ketiga, tugas yang telah dilakukan meliputi:

- Implementasi penyimpanan lokal menggunakan SQLite
- Implementasi Create Notes (menambahkan catatan baru)
- Implementasi Read Notes (menampilkan daftar catatan)
- Implementasi Update Notes (memperbarui catatan)
- Implementasi Delete Notes (menghapus catatan)
- Proteksi NotesService berdasarkan pengguna yang sedang login

## Deskripsi Singkat

Pada minggu ini pengembangan difokuskan pada penyempurnaan fitur utama aplikasi Notes dengan mengimplementasikan sistem CRUD secara lengkap menggunakan SQLite sebagai penyimpanan lokal serta integrasi ke Cloud Firestore sebagai backend, sehingga data dapat dikelola secara fleksibel. Seluruh operasi tambah, baca, ubah, dan hapus catatan telah berjalan dengan dukungan stream untuk pembaruan real-time, serta layanan dibatasi agar hanya pengguna yang sedang login yang dapat mengakses data mereka sendiri sehingga keamanan dan struktur aplikasi menjadi lebih optimal.

## Hasil Implementasi

Semua fitur CRUD pada Notes sudah berfungsi dengan optimal, termasuk integrasi real-time dengan Cloud Firestore serta penyimpanan lokal, sehingga aplikasi dapat digunakan untuk mengelola dan membagikan catatan dengan lancar:
<img src="https://github.com/user-attachments/assets/e3492354-da01-4df4-babc-819a8509f380" width="800">

<p align="left">
  <img src="https://github.com/user-attachments/assets/7cd956c4-01eb-4685-bf37-6a0755c88f00" width="250"/>
  <img src="https://github.com/user-attachments/assets/46d1e8df-a005-466a-96e3-bf840f01372d" width="250"/>
  <img src="https://github.com/user-attachments/assets/5ae6a1d0-ee30-482b-97c6-a23ba9863a53" width="250"/>
</p>
<p align="left">
  <img src="https://github.com/user-attachments/assets/eb7d963c-dfe8-4493-9964-1e22cbda8f20" width="250"/>
  <img src="https://github.com/user-attachments/assets/ef16bf41-925c-405f-87e2-7dae207ec9b7" width="250"/>
</p>
