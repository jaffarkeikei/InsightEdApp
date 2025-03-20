import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:insighted/domain/entities/result.dart';
import 'package:insighted/domain/entities/school.dart';
import 'package:insighted/domain/entities/student.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportGenerator {
  final PdfColor primaryColor = PdfColor.fromInt(0xFF1A5D1A);
  final PdfColor accentColor = PdfColor.fromInt(0xFF2E8B57);
  final PdfColor backgroundColor = PdfColor.fromInt(0xFFF5F5F5);
  final PdfColor textColor = PdfColor.fromInt(0xFF212121);
  final PdfColor lightTextColor = PdfColor.fromInt(0xFF757575);

  Future<Uint8List> generateReport({
    required School school,
    required Student student,
    required String className,
    required String grade,
    required String term,
    required int academicYear,
    required List<Result> results,
    required double averageMark,
    required String? overallGrade,
    required int? position,
    required int? totalStudents,
    required Map<String, double> subjectAverages,
    required String? teacherComments,
    required String? principalComments,
    required String? parentComments,
    String? schoolLogo,
  }) async {
    final pdf = pw.Document();

    // Load fonts
    final regularFont = await PdfGoogleFonts.nunitoRegular();
    final boldFont = await PdfGoogleFonts.nunitoBold();
    final italicFont = await PdfGoogleFonts.nunitoItalic();

    // Load school logo if available
    pw.MemoryImage? logoImage;
    if (schoolLogo != null) {
      try {
        final logoBytes = await rootBundle.load(schoolLogo);
        logoImage = pw.MemoryImage(
          logoBytes.buffer.asUint8List(
            logoBytes.offsetInBytes,
            logoBytes.lengthInBytes,
          ),
        );
      } catch (e) {
        // Handle logo loading failure
        print('Error loading school logo: $e');
      }
    }

    // Add student report card PDF page
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header:
            (context) => _buildHeader(
              school: school,
              term: term,
              academicYear: academicYear,
              grade: grade,
              regularFont: regularFont,
              boldFont: boldFont,
              logoImage: logoImage,
            ),
        footer:
            (context) => _buildFooter(
              context,
              regularFont: regularFont,
              italicFont: italicFont,
            ),
        build:
            (context) => [
              _buildStudentInfoSection(
                student: student,
                className: className,
                position: position,
                totalStudents: totalStudents,
                regularFont: regularFont,
                boldFont: boldFont,
              ),
              pw.SizedBox(height: 20),
              _buildResultsTable(
                results: results,
                regularFont: regularFont,
                boldFont: boldFont,
              ),
              pw.SizedBox(height: 20),
              _buildPerformanceChart(
                subjectAverages: subjectAverages,
                regularFont: regularFont,
                boldFont: boldFont,
              ),
              pw.SizedBox(height: 20),
              _buildCommentsSection(
                teacherComments: teacherComments,
                principalComments: principalComments,
                parentComments: parentComments,
                regularFont: regularFont,
                boldFont: boldFont,
                italicFont: italicFont,
              ),
            ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader({
    required School school,
    required String term,
    required int academicYear,
    required String grade,
    required pw.Font regularFont,
    required pw.Font boldFont,
    pw.MemoryImage? logoImage,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            if (logoImage != null)
              pw.Container(
                height: 60,
                width: 60,
                margin: const pw.EdgeInsets.only(right: 10),
                child: pw.Image(logoImage),
              ),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    school.name.toUpperCase(),
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 18,
                      color: primaryColor,
                    ),
                  ),
                  if (school.address != null)
                    pw.Text(
                      school.address!,
                      style: pw.TextStyle(font: regularFont, fontSize: 10),
                    ),
                  if (school.county != null)
                    pw.Text(
                      school.county!,
                      style: pw.TextStyle(font: regularFont, fontSize: 10),
                    ),
                  if (school.phoneNumber != null || school.email != null)
                    pw.Text(
                      [
                        if (school.phoneNumber != null)
                          'Tel: ${school.phoneNumber}',
                        if (school.email != null) 'Email: ${school.email}',
                      ].join(' | '),
                      style: pw.TextStyle(font: regularFont, fontSize: 8),
                    ),
                ],
              ),
            ),
            if (logoImage != null) pw.SizedBox(width: 60), // For balance
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(vertical: 5),
          decoration: pw.BoxDecoration(
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
            color: primaryColor,
          ),
          child: pw.Center(
            child: pw.Text(
              'GRADE $grade END OF $term $academicYear',
              style: pw.TextStyle(
                font: boldFont,
                color: PdfColors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Divider(color: PdfColors.grey),
      ],
    );
  }

  pw.Widget _buildFooter(
    pw.Context context, {
    required pw.Font regularFont,
    required pw.Font italicFont,
  }) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'This is an official report from ${DateTime.now().year}',
            style: pw.TextStyle(
              font: italicFont,
              color: lightTextColor,
              fontSize: 8,
            ),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(
              font: regularFont,
              color: lightTextColor,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildStudentInfoSection({
    required Student student,
    required String className,
    required int? position,
    required int? totalStudents,
    required pw.Font regularFont,
    required pw.Font boldFont,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
        color: backgroundColor,
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  'Student Name',
                  student.name,
                  regularFont: regularFont,
                  boldFont: boldFont,
                ),
                _buildInfoRow(
                  'Student Number',
                  student.studentNumber,
                  regularFont: regularFont,
                  boldFont: boldFont,
                ),
                _buildInfoRow(
                  'Class',
                  className,
                  regularFont: regularFont,
                  boldFont: boldFont,
                ),
              ],
            ),
          ),
          pw.SizedBox(width: 20),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  'Gender',
                  student.gender,
                  regularFont: regularFont,
                  boldFont: boldFont,
                ),
                if (position != null && totalStudents != null)
                  _buildInfoRow(
                    'Position',
                    '$position out of $totalStudents',
                    regularFont: regularFont,
                    boldFont: boldFont,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildInfoRow(
    String label,
    String value, {
    required pw.Font regularFont,
    required pw.Font boldFont,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(font: boldFont, fontSize: 10),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(font: regularFont, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildResultsTable({
    required List<Result> results,
    required pw.Font regularFont,
    required pw.Font boldFont,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      children: [
        // Header Row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: primaryColor),
          children: [
            _buildTableHeaderCell('SUBJECT', regularFont),
            _buildTableHeaderCell('MARKS 1', regularFont),
            _buildTableHeaderCell('MARKS 2', regularFont),
            _buildTableHeaderCell('MARKS 3', regularFont),
            _buildTableHeaderCell('AVERAGE', regularFont),
            _buildTableHeaderCell('GRADE', regularFont),
            _buildTableHeaderCell('COMMENT', regularFont),
          ],
        ),
        // Result Rows
        ...results.asMap().entries.map((entry) {
          final index = entry.key;
          final result = entry.value;
          // Group results by subject and show multiple marks if available
          return pw.TableRow(
            decoration: pw.BoxDecoration(
              color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
            ),
            children: [
              _buildTableCell(
                result.subjectName,
                regularFont,
                alignment: pw.Alignment.centerLeft,
              ),
              _buildTableCell('${result.marks}', regularFont),
              _buildTableCell(
                '-',
                regularFont,
              ), // Placeholder for additional marks
              _buildTableCell(
                '-',
                regularFont,
              ), // Placeholder for additional marks
              _buildTableCell(
                '${result.marks}',
                boldFont,
              ), // Assuming single mark for now
              _buildTableCell(result.grade ?? '-', boldFont),
              _buildTableCell(
                result.comments ?? '-',
                regularFont,
                alignment: pw.Alignment.centerLeft,
              ),
            ],
          );
        }),
        // Average Row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: accentColor.shade(50)),
          children: [
            _buildTableCell(
              'OVERALL AVERAGE',
              boldFont,
              color: textColor,
              alignment: pw.Alignment.centerLeft,
            ),
            _buildTableCell('', regularFont),
            _buildTableCell('', regularFont),
            _buildTableCell('', regularFont),
            _buildTableCell(
              _formatNumber(
                results.isEmpty
                    ? 0
                    : results.map((r) => r.marks).reduce((a, b) => a + b) /
                        results.length,
              ),
              boldFont,
              color: textColor,
            ),
            _buildTableCell(
              _calculateGrade(
                results.isEmpty
                    ? 0
                    : results.map((r) => r.marks).reduce((a, b) => a + b) /
                        results.length,
              ),
              boldFont,
              color: textColor,
            ),
            _buildTableCell('', regularFont),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildTableHeaderCell(
    String text,
    pw.Font font, {
    pw.Alignment alignment = pw.Alignment.center,
  }) {
    return pw.Container(
      alignment: alignment,
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, color: PdfColors.white, fontSize: 9),
      ),
    );
  }

  pw.Widget _buildTableCell(
    String text,
    pw.Font font, {
    PdfColor? color,
    pw.Alignment alignment = pw.Alignment.center,
  }) {
    return pw.Container(
      alignment: alignment,
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, color: color ?? textColor, fontSize: 9),
      ),
    );
  }

  pw.Widget _buildPerformanceChart({
    required Map<String, double> subjectAverages,
    required pw.Font regularFont,
    required pw.Font boldFont,
  }) {
    // Sort subjects by marks in descending order
    final sortedSubjects =
        subjectAverages.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    final maxMark =
        sortedSubjects.isEmpty
            ? 100
            : sortedSubjects
                .map((e) => e.value)
                .reduce((a, b) => a > b ? a : b);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: pw.BoxDecoration(
            color: primaryColor,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
          ),
          child: pw.Text(
            'PERFORMANCE ANALYSIS',
            style: pw.TextStyle(
              font: boldFont,
              color: PdfColors.white,
              fontSize: 12,
            ),
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Container(
          height: 200,
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              // Y-axis
              pw.Container(
                width: 40,
                height: 180,
                child: pw.Stack(
                  alignment: pw.Alignment.centerLeft,
                  children: [
                    pw.Positioned(
                      bottom: 0,
                      left: 0,
                      child: pw.Text(
                        '0',
                        style: pw.TextStyle(font: regularFont, fontSize: 8),
                      ),
                    ),
                    pw.Positioned(
                      bottom: 180 * 0.25,
                      left: 0,
                      child: pw.Text(
                        '${(maxMark * 0.25).round()}',
                        style: pw.TextStyle(font: regularFont, fontSize: 8),
                      ),
                    ),
                    pw.Positioned(
                      bottom: 180 * 0.5,
                      left: 0,
                      child: pw.Text(
                        '${(maxMark * 0.5).round()}',
                        style: pw.TextStyle(font: regularFont, fontSize: 8),
                      ),
                    ),
                    pw.Positioned(
                      bottom: 180 * 0.75,
                      left: 0,
                      child: pw.Text(
                        '${(maxMark * 0.75).round()}',
                        style: pw.TextStyle(font: regularFont, fontSize: 8),
                      ),
                    ),
                    pw.Positioned(
                      bottom: 180,
                      left: 0,
                      child: pw.Text(
                        '${maxMark.round()}',
                        style: pw.TextStyle(font: regularFont, fontSize: 8),
                      ),
                    ),
                  ],
                ),
              ),
              // Bars
              pw.Expanded(
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children:
                      sortedSubjects.map((entry) {
                        final subject = entry.key;
                        final mark = entry.value;
                        final percentage = maxMark > 0 ? mark / maxMark : 0;
                        return pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Container(
                              width: 30,
                              height: 180 * percentage.toDouble(),
                              color: primaryColor,
                            ),
                            pw.SizedBox(height: 5),
                            pw.SizedBox(
                              width: 30,
                              child: pw.Text(
                                _abbreviateSubject(subject),
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  font: regularFont,
                                  fontSize: 6,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildCommentsSection({
    required String? teacherComments,
    required String? principalComments,
    required String? parentComments,
    required pw.Font regularFont,
    required pw.Font boldFont,
    required pw.Font italicFont,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (teacherComments != null) ...[
          _buildCommentField(
            'CLASS TEACHER\'S COMMENTS',
            teacherComments,
            regularFont: regularFont,
            boldFont: boldFont,
          ),
          pw.SizedBox(height: 10),
        ],
        if (principalComments != null) ...[
          _buildCommentField(
            'PRINCIPAL\'S COMMENTS',
            principalComments,
            regularFont: regularFont,
            boldFont: boldFont,
          ),
          pw.SizedBox(height: 10),
        ],
        if (parentComments != null) ...[
          _buildCommentField(
            'PARENT\'S COMMENTS',
            parentComments,
            regularFont: regularFont,
            boldFont: boldFont,
          ),
          pw.SizedBox(height: 10),
        ],
        pw.SizedBox(height: 20),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _buildSignatureField(
              'CLASS TEACHER',
              regularFont: regularFont,
              boldFont: boldFont,
            ),
            _buildSignatureField(
              'PRINCIPAL',
              regularFont: regularFont,
              boldFont: boldFont,
            ),
            _buildSignatureField(
              'PARENT/GUARDIAN',
              regularFont: regularFont,
              boldFont: boldFont,
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildCommentField(
    String label,
    String comment, {
    required pw.Font regularFont,
    required pw.Font boldFont,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 10,
            color: primaryColor,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
          ),
          child: pw.Text(
            comment,
            style: pw.TextStyle(font: regularFont, fontSize: 10),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSignatureField(
    String label, {
    required pw.Font regularFont,
    required pw.Font boldFont,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: pw.TextStyle(font: boldFont, fontSize: 10)),
        pw.SizedBox(height: 20),
        pw.Container(
          width: 120,
          decoration: const pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(color: PdfColors.black)),
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          'Date: _________________',
          style: pw.TextStyle(font: regularFont, fontSize: 8),
        ),
      ],
    );
  }

  String _formatNumber(double number) {
    return number.toStringAsFixed(1);
  }

  String _calculateGrade(double average) {
    if (average >= 90) return 'A+';
    if (average >= 80) return 'A';
    if (average >= 70) return 'B+';
    if (average >= 60) return 'B';
    if (average >= 50) return 'C+';
    if (average >= 40) return 'C';
    if (average >= 30) return 'D+';
    if (average >= 20) return 'D';
    return 'E';
  }

  String _abbreviateSubject(String subject) {
    // Use first 3 letters of each word
    final words = subject.split(' ');
    if (words.length > 1) {
      return words
          .map((word) => word.isNotEmpty ? word[0] : '')
          .join('')
          .toUpperCase();
    } else if (subject.length > 3) {
      return subject.substring(0, 3).toUpperCase();
    }
    return subject.toUpperCase();
  }

  Future<void> printPdf(Uint8List pdfData) async {
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
  }

  Future<File> savePdf(Uint8List pdfData, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(pdfData);
    return file;
  }
}
