import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/api/sheets/user_sheets.dart';
import 'package:webapp/auth.dart';
import 'package:webapp/widgets/data_widget.dart';
import 'package:webapp/widgets/github_icon.dart';
import 'package:webapp/widgets/nav_bar.dart';
import 'package:webapp/widgets/socials_row.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    List<String>? parts = auth.user?.displayName?.split('-');
    final rollnumber = parts?[0].trim().toLowerCase();
    final name = parts?[1].trim();

    return Scaffold(
      appBar: const UniversalNavBar(),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
          ),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                "Welcome $name",
                style: const TextStyle(fontSize: 24),
              ),
              FutureBuilder<Map<String, String>?>(
                  future: UserSheetsApi.getRollNumberData(
                      rollNumber: rollnumber, sheetName: "Lab"),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    return DataCard(
                      rollData: snapshot.data!,
                      heading: "Lab",
                    );
                  }),
              FutureBuilder<Map<String, String>?>(
                  future: UserSheetsApi.getRollNumberData(
                      rollNumber: rollnumber, sheetName: "Class"),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    return DataCard(
                      rollData: snapshot.data!,
                      heading: "Class",
                    );
                  }),
              const Text(
                "Made by Zephaniah Qamar bitf23m544 :)",
                textAlign: TextAlign.center,
              ),
              SocialsRow(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
