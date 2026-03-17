import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../themes.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      backgroundColor: MotifaTheme.backgroundWhite,
      appBar: AppBar(
        title: const Text(
          'RIWAYAT SCAN',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: MotifaTheme.backgroundWhite,
          ),
        ),
        backgroundColor: MotifaTheme.primaryBlue,
        iconTheme: const IconThemeData(color: MotifaTheme.backgroundWhite),
        scrolledUnderElevation: 0,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: Container(color: MotifaTheme.black, height: 3.0),
        ),
      ),
      body: user == null
          ? const Center(child: Text('Silakan login untuk melihat riwayat.'))
          : StreamBuilder<QuerySnapshot>(
              stream: firestoreService.getUserHistoryStream(user.uid),
              builder: (context, snapshot) {
                // loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // error
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Terjadi kesalahan: ${snapshot.error}'),
                  );
                }

                // kosong
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history_toggle_off,
                          size: 80,
                          color: MotifaTheme.black.withOpacity(0.2),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Belum ada riwayat scan.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // ada data
                return ListView.separated(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: docs.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 24),
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final String name = data['name'] ?? '-';
                    final double accuracy =
                        (data['accuracy'] as num?)?.toDouble() ?? 0.0;
                    final Timestamp? createdAt = data['createdAt'];

                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: MotifaTheme.backgroundWhite,
                        border: MotifaTheme.brutalBorder,
                        boxShadow: MotifaTheme.brutalShadowSmall,
                      ),
                      child: Row(
                        children: [
                          // detail info
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (createdAt != null)
                                    Text(
                                      _formatDate(createdAt.toDate()),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: MotifaTheme.primaryBlue,
                                      border: Border.all(
                                        color: MotifaTheme.black,
                                      ),
                                    ),
                                    child: Text(
                                      'Cocok ${(accuracy * 100).toStringAsFixed(1)}%',
                                      style: const TextStyle(
                                        color: MotifaTheme.backgroundWhite,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // panah aksi
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: MotifaTheme.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}  '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
