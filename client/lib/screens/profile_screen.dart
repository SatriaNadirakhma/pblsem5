import 'package:client/models/employee_model.dart';
import 'package:client/models/user_model.dart';
import 'package:client/services/auth_service.dart';
import 'package:client/services/user_service.dart';
import 'package:client/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final int? userId;

  const ProfileScreen({super.key, this.userId});

  //Dummy Untuk Test UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: ""),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: UserService.instance.getUser(userId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return profileSection(context, snapshot.data?.data);
          },
        ),
      ),
    );
  }
}

String parseGender(String gender) {
  if (gender == "P") {
    return "Perempuan";
  }
  if (gender == "L") {
    return "Laki-Laki";
  }
  return "";
}

Widget profileSection(BuildContext context, UserModel<EmployeeModel>? user) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        decoration: const BoxDecoration(color: Color(0xFF22A9D6)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Informasi Profil",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            const Text(
              "Data diri pegawai",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 16),

            // Form fields
            const _ProfileField(title: "Nama Awal", value: "John"),
            const _ProfileField(title: "Nama Akhir", value: "Doe"),
            const _ProfileField(title: "Email", value: "JohnDoe@gmail.com"),
            const _ProfileField(title: "Jenis Kelamin", value: "Pria"),
            const _ProfileField(
              title: "Alamat",
              value: "Jalan Jakarta no. 10, Jakarta Indonesia",
            ),
            const _ProfileField(title: "Jabatan", value: "Front-End Developer"),
            const _ProfileField(
              title: "Departemen",
              value: "Teknologi Informasi",
            ),

              const SizedBox(height: 20),

            // Tombol Informasi Gaji
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Informasi Gaji",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Tombol Edit Profil
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Edit Profil",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    ],
  );
}

// Widget Custom untuk Field
class _ProfileField extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;

  const _ProfileField({required this.title, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),

        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.1),
                blurRadius: 3,
                offset: const Offset(1, 2),
              ),
            ],
          ),
          child: TextField(
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: color ?? const Color(0xfff1f1f1),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintText: value,
              hintStyle: const TextStyle(color: Colors.black87, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
