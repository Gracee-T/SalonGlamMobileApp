import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salon_glam/models/hairstyle_model.dart';
import 'package:salon_glam/pages/payment_gateway.dart';
import 'package:salon_glam/widgets/custom_app_bar.dart';
import 'package:salon_glam/widgets/theme/custom_theme.dart';

class BookAppointmentsPages extends StatefulWidget {
  const BookAppointmentsPages({super.key, required this.selectedService});

  final Hairstyle selectedService;

  @override
  _BookAppointmentsPagesState createState() => _BookAppointmentsPagesState();
}

class _BookAppointmentsPagesState extends State<BookAppointmentsPages> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedStylist;
  List<String> availableStylists = [];
  bool isLoading = false;

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      _fetchAvailableStylists();
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
      _fetchAvailableStylists();
    }
  }

  Future<void> _fetchAvailableStylists() async {
    if (_selectedDate == null || _selectedTime == null) return;

    setState(() {
      isLoading = true;
    });

    String formatedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    print(_selectedTime!.format(context));

    final QuerySnapshot stylistSnapshot = await FirebaseFirestore.instance
        .collection('Stylists')
        .where('availableDate', isEqualTo: formatedDate)
        .where('availableTime', isEqualTo: _selectedTime!.format(context))
        .get();

    setState(() {
      availableStylists =
          stylistSnapshot.docs.map((doc) => doc['name'] as String).toList();
      isLoading = false;
    });
  }

  Future<void> _submitAppointment() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null ||
          _selectedTime == null ||
          _selectedStylist == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete all selections')),
        );
        return;
      }

      final currentUser = FirebaseAuth.instance.currentUser!;
      final String reason = _reasonController.text;

      DateTime appointmentDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      Timestamp appointmentTimestamp = Timestamp.fromDate(appointmentDateTime);

      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('Bookings').add({
        'userId': currentUser.uid,
        'userName': currentUser.displayName,
        'userEmail': currentUser.email,
        'reason': reason,
        'appointmentDateTime': appointmentTimestamp,
        'stylist': _selectedStylist,
        'status': 'pending',
        'serviceName': widget.selectedService.name,
        'price': widget.selectedService.price,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your booking has been submitted')),
      );

      _reasonController.clear();
      setState(() {
        _selectedDate = null;
        _selectedTime = null;
        _selectedStylist = null;
      });

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PaymentGatewayPage(appointmentId: docRef.id),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Book an Appointment',
      bodyContent: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/background.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 80.0,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 20.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Select',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: lightColorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Selected Service: ${widget.selectedService.name}',
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Price: \$${widget.selectedService.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 50, 53, 233),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: Text(
                            _selectedDate == null
                                ? 'No date selected'
                                : '${_selectedDate!.toLocal()}'.split(' ')[0],
                          ),
                          trailing: ElevatedButton(
                            onPressed: _pickDate,
                            child: const Text('Pick Date'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          leading: const Icon(Icons.access_time),
                          title: Text(
                            _selectedTime == null
                                ? 'No time selected'
                                : _selectedTime!.format(context),
                          ),
                          trailing: ElevatedButton(
                            onPressed: _pickTime,
                            child: const Text('Pick Time'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (availableStylists.isEmpty)
                          const Text('No stylists available')
                        else
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Available Stylists',
                              border: OutlineInputBorder(),
                            ),
                            value: _selectedStylist,
                            onChanged: (value) {
                              setState(() {
                                _selectedStylist = value!;
                              });
                            },
                            items: availableStylists
                                .map((stylist) => DropdownMenuItem<String>(
                                      value: stylist,
                                      child: Text(stylist),
                                    ))
                                .toList(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a stylist';
                              }
                              return null;
                            },
                          ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _reasonController,
                          decoration: const InputDecoration(
                            labelText: 'Additional Notes',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a reason';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submitAppointment,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
