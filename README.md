# LabMarks-webapp

This webapp is built to view data from a provided google sheet.
It was build to view Lab marks for my OOP course. The instructor wanted to maintain privacy so sheet was not shared
I made this app that authenticates only uni domain google acounts, extracts roll number from the email and
then looks up and returns the row for that roll number.

- Note: you will need a google cloud service acount to use the sheets api

### This web app is deployed on firebase, you can check it out through this link:

- https://labmarks-79810.web.app/
  You won't be able to auth without a PUCIT acount though

## Sheets API Usage:

The API dirctory within main was not shared as it contains secrets and I am too lazy to setup a secure way of storing them
I will however paste it here without the secret:

```

import 'package:gsheets/gsheets.dart';

class UserSheetsApi {
static const \_credentials = r''' // add the service account credentials here
{}
''';
static const \_spreadsheetId = ''; // add your sheet identifier here

static final \_gsheets = GSheets(\_credentials);

// Map to store multiple worksheets
static final Map<String, Worksheet> \_worksheets = {};

static Future init({required List<String> sheetNames}) async {
final Spreadsheet = await \_gsheets.spreadsheet(\_spreadsheetId);

    // Loop through sheet names, get the sheet and add to map
    for (String sheetName in sheetNames) {
      Worksheet worksheet = await _getWorkSheet(Spreadsheet, title: sheetName);
      _worksheets[sheetName] = worksheet;
    }

}

static Future<Worksheet> \_getWorkSheet(
Spreadsheet spreadsheet, {
required String title,
}) async {
try {
return await spreadsheet.addWorksheet(title);
} catch (e) {
return spreadsheet.worksheetByTitle(title)!;
}
}

// Member function to get the data for a specific roll number
static Future<Map<String, String>> getRollNumberData(
{required String? rollNumber, required String sheetName}) async {
final worksheet = \_worksheets[sheetName]; // Get the correct worksheet
if (worksheet == null) {
print("Worksheet not found: $sheetName");
return {"Error": "Sheet Not found"};
}

    if (rollNumber == null || rollNumber.isEmpty) {
      return {"Error": "Invalid roll number"};
    }

    try {
      // Get all rows to find the headers first
      final rows = await worksheet.values.allRows();

      if (rows.isEmpty) {
        return {"Error": "Sheet is empty"};
      }

      // Find first non-empty row for headers
      int headerRowIndex = -1;
      List<String> headers = [];

      for (int i = 0; i < rows.length; i++) {
        if (rows[i].any((cell) => cell.isNotEmpty)) {
          headerRowIndex = i;
          headers = rows[i].map((e) => e.toString()).toList();
          break;
        }
      }

      if (headerRowIndex == -1) {
        return {"Error": "No headers found in sheet"};
      }

      // Find the index of the column containing "roll" (case-insensitive)
      int rollNumberColumnIndex = headers.indexWhere(
        (header) => header.toLowerCase().contains("roll"),
      );

      if (rollNumberColumnIndex == -1) {
        return {"Error": "Roll number column not found"};
      }

      // Find the roll number in the first column
      int studentRowIndex = -1;
      for (int i = headerRowIndex + 1; i < rows.length; i++) {
        if (rows[i].isNotEmpty &&
            rows[i][rollNumberColumnIndex].toLowerCase() == rollNumber.toLowerCase()) {
          studentRowIndex = i;
          break;
        }
      }

      if (studentRowIndex == -1) {
        return {"Error": "Roll number not found"};
      }

      // Get student data
      final studentData = rows[studentRowIndex];
      final dataMap = <String, String>{};
      int total = 0;

      // Start from 1 to skip roll number column
      for (int i = 1; i < headers.length; i++) {
        // Skip columns that have "roll" or "name" in the header
        if (headers[i].toLowerCase().contains("roll") ||
            headers[i].toLowerCase().contains("name")) {
          continue;
        }

        // Get the value, handling the case where the index might be out of bounds
        String value = (i < studentData.length) ? studentData[i].toString().trim() : '';

        // If empty or doesn't exist, mark as "unmarked"
        value = value.isEmpty ? 'unmarked' : value;
        dataMap[headers[i]] = value;

        // Add to total if it's a number
        int? number = int.tryParse(value);
        if (number != null) {
          total += number;
        }
      }

      dataMap["Total"] = total.toString();
      return dataMap;
    } catch (e) {
      return {"Error": "Failed to fetch data: ${e.toString()}"};
    }

}
}

```
