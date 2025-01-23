import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salon_glam/widgets/custom_app_bar.dart';

class ViewAppointmentPage extends StatelessWidget {
  const ViewAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'View Appointments',
      bodyContent: _ViewAppointmentBody(),
    );
  }
}

class _ViewAppointmentBody extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<List<Map<String, dynamic>>> _fetchAppointments() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('userId', isEqualTo: currentUser.uid)
        .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchAppointments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading appointments.'));
        }

        final appointments = snapshot.data ?? [];

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(context).size.height * 0.8, // Set a max height
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    'Appointments',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: appointments.isEmpty
                      ? const Center(child: Text('No appointments found.'))
                      : ListView.builder(
                          itemCount: appointments.length,
                          itemBuilder: (context, index) {
                            return _buildAppointmentCard(
                              appointments[index],
                              index + 1, // Using index + 1 for display
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment, int index) {
    final appointmentDateTime = appointment['appointmentDateTime'].toDate();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appointment [$index]',
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(
              'Date: ${appointmentDateTime.toLocal().toString().split(' ')[0]}'),
          Text(
              'Time: ${appointmentDateTime.hour}:${appointmentDateTime.minute.toString().padLeft(2, '0')}'),
          Text('Style: ${appointment['serviceName']}'),
          Text('Stylist: ${appointment['stylist']}'),
          Text('Status: ${appointment['status']}'),
        ],
      ),
    );
  }
}
