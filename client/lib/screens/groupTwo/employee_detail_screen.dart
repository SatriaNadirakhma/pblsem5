import 'package:client/models/employee_model.dart';
import 'package:client/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final EmployeeModel employee;
  final bool isKaryawanMode;

  const EmployeeDetailScreen({
    super.key,
    required this.employee,
    required this.isKaryawanMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(employee.fullName),
        backgroundColor: const Color.fromRGBO(29, 97, 231, 1),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Center(
                child: CircleAvatar(
                  backgroundColor: const Color.fromRGBO(29, 97, 231, 1),
                  radius: 50,
                  child: Text(
                    employee.fullName.isNotEmpty
                        ? employee.fullName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Info Cards
              _buildInfoCard('Nama Depan', employee.firstName),
              _buildInfoCard('Nama Belakang', employee.lastName),
              _buildInfoCard(
                'Jenis Kelamin',
                employee.gender == 'L' ? 'Laki-laki' : 'Perempuan',
              ),
              _buildInfoCard('Alamat', employee.address),
              _buildInfoCard('Status', employee.employmentStatus),
              _buildInfoCard('Posisi', employee.position?.name ?? '-'),
              _buildInfoCard('Departemen', employee.department?.name ?? '-'),

              const SizedBox(height: 30),

              // Action Button
              if (isKaryawanMode)
                CustomButton(
                  backgroundColor: const Color.fromRGBO(29, 97, 231, 1),
                  onPressed: () {
                    context.push(
                      '/employee/edit-personal/${employee.id}',
                      extra: employee,
                    );
                  },
                  child: const Text(
                    'Edit Data Pribadi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                CustomButton(
                  backgroundColor: const Color.fromRGBO(29, 97, 231, 1),
                  onPressed: () {
                    context.push(
                      '/employee/edit-management/${employee.id}',
                      extra: employee,
                    );
                  },
                  child: const Text(
                    'Edit Status, Posisi & Departemen',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color.fromRGBO(108, 114, 120, 1),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
