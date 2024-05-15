import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../models/complaint.dart';
import '../services/auth_service.dart';
import 'add_complaint_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).user;
    final complaintBox = Hive.box<Complaint>('complaints');
    final isAdmin = user?.isAdmin ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user?.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: complaintBox.listenable(),
        builder: (context, Box<Complaint> box, _) {
          final complaints = isAdmin
              ? box.values.toList()
              : box.values.where((c) => c.postedBy == user?.email).toList();

          return ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaint = complaints[index];
              final postedBy = 'Posted by: ${complaint.postedBy}';
              final description = '${postedBy}\n${complaint.description}';
              return ListTile(
                title: Text(complaint.title),
                subtitle: Text(description),
                trailing: isAdmin
                    ? Checkbox(
                        value: complaint.isSolved,
                        onChanged: (bool? value) {
                          final updatedComplaint = Complaint(
                            title: complaint.title,
                            description: complaint.description,
                            level: complaint.level,
                            isSolved: value ?? false,
                            postedBy: complaint.postedBy,
                          );
                          box.putAt(index, updatedComplaint);
                        },
                      )
                    : Text(complaint.isSolved ? 'Resolved' : 'Unresolved'),
              );
            },
          );
        },
      ),
      floatingActionButton: !isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddComplaintScreen()),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
