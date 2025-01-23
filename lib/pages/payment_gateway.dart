import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salon_glam/models/appointment_model.dart';
// Import the Appointment model

class PaymentGatewayPage extends StatelessWidget {
  final String appointmentId;

  const PaymentGatewayPage({super.key, required this.appointmentId});

  Future<Appointment?> _fetchAppointmentDetails() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Bookings')
        .doc(appointmentId)
        .get();
    if (doc.exists) {
      return Appointment(
        userId: doc['userId'],
        userName: doc['userName'],
        userEmail: doc['userEmail'],
        reason: doc['reason'],
        appointmentDateTime: (doc['appointmentDateTime'] as Timestamp).toDate(),
        stylist: doc['stylist'],
        status: doc['status'],
        price: doc['price'],
        serviceName: doc['serviceName'],
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Gateway'),
      ),
      body: FutureBuilder<Appointment?>(
        future: _fetchAppointmentDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
                child: Text('Error fetching appointment details.'));
          }

          Appointment appointment = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Appointment Details',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 20),
                Text('Stylist: ${appointment.stylist}'),
                Text('Date: ${appointment.appointmentDateTime}'),
                Text('Reason: ${appointment.reason}'),
                const SizedBox(height: 20),
                Text(
                    'Total Price: \$${calculateTotalPrice()}'), // Replace with actual calculation
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    // Implement the payment logic here
                    await FirebaseFirestore.instance
                        .collection('appointments')
                        .add({
                      'userId': appointment.userId,
                      'userName': appointment.userName,
                      'userEmail': appointment.userEmail,
                      'reason': appointment.reason,
                      'appointmentDateTime':
                          Timestamp.fromDate(appointment.appointmentDateTime),
                      'stylist': appointment.stylist,
                      'status': 'Paid',
                      'serviceName': appointment.serviceName,
                      'price': appointment.price,
                    });
                    // After payment, update appointment status in Firestore
                    await FirebaseFirestore.instance
                        .collection('Bookings')
                        .doc(appointmentId)
                        .update({
                      'status': 'Paid',
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Your payment was successful.')),
                    );
                    Navigator.pop(
                        context); // Navigate back to the home page or initial route
                  },
                  child: const Text('Pay Now'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  double calculateTotalPrice() {
    // Implement the logic for calculating the total price
    return 100.00; // Replace this with actual logic to calculate total price based on selected services
  }
}
