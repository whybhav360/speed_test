import 'package:flutter/material.dart';
import 'package:flutter_speed_test_plus/flutter_speed_test_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({super.key});

  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  final speedTest = FlutterInternetSpeedTest();
  double _downloadSpeed = 0;
  double _uploadSpeed = 0;
  double _progress = 0;
  bool _isTesting = false;
  String _unit = 'Mbps';

  void startSpeedTest() {
    setState(() {
      _isTesting = true;
      _downloadSpeed = 0;
      _uploadSpeed = 0;
      _progress = 0;
    });

    speedTest.startTesting(
      useFastApi: true,
      onStarted: () {
        setState(() {
          _isTesting = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Test started')),
        );
      },
      onCompleted: (TestResult download, TestResult upload) {
        setState(() {
          _downloadSpeed = download.transferRate;
          _uploadSpeed = upload.transferRate;
          _unit = download.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
          _isTesting = false;
          _progress = 100;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Test completed')),
        );
      },
      onProgress: (double percent, TestResult data) {
        setState(() {
          _progress = percent;
          _unit = data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
          if (data.type == TestType.download) {
            _downloadSpeed = data.transferRate;
          } else {
            _uploadSpeed = data.transferRate;
          }
        });
      },
      onError: (String errorMessage, String speedTestError) {
        setState(() {
          _isTesting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $errorMessage')),
        );
      },
      onDownloadComplete: (TestResult data) {
        setState(() {
          _downloadSpeed = data.transferRate;
          _unit = data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
        });
      },
      onUploadComplete: (TestResult data) {
        setState(() {
          _uploadSpeed = data.transferRate;
          _unit = data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
        });
      },
      onCancel: () {
        setState(() {
          _isTesting = false;
          _downloadSpeed = 0;
          _uploadSpeed = 0;
          _progress = 0;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Test cancelled')),
        );
      },
    );
  }

  void cancelSpeedTest() {
    speedTest.cancelTest();
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('Speed Test Report', style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text('Download Speed: ${_downloadSpeed.toStringAsFixed(2)} $_unit'),
                pw.Text('Upload Speed: ${_uploadSpeed.toStringAsFixed(2)} $_unit'),
                pw.SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speed Test'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Progress: ${_progress.toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: LinearProgressIndicator(value: _progress / 100),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSpeedColumn('Download', _downloadSpeed, _unit, Colors.green),
                _buildSpeedColumn('Upload', _uploadSpeed, _unit, Colors.blue),
              ],
            ),
            const SizedBox(height: 50),
            if (!_isTesting)
              ElevatedButton(
                onPressed: startSpeedTest,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Start Speed Test'),
              )
            else
              ElevatedButton(
                onPressed: cancelSpeedTest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Cancel Test'),
              ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 28.0),
        child: FloatingActionButton(
          onPressed: _generatePdf,
          tooltip: 'Save as PDF',
          child: const Icon(Icons.picture_as_pdf),
        ),
      ),
    );
  }

  Widget _buildSpeedColumn(String label, double value, String unit, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(unit, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
